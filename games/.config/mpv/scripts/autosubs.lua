local mp = require 'mp'
local utils = require 'mp.utils'

mp.msg.info("--- Carregando script autosubs... ---")

-- Configurações
local LANGUAGE = "pt-BR" -- Idioma desejado
local EXECUTABLE = (os.getenv("HOME") or "~") .. "/.local/bin/subliminal" -- Caminho absoluto seguro

-- Função de callback quando o processo termina
local function on_download_finish(success, result, error)
    if result.status == 0 then
        mp.osd_message("Legenda baixada com sucesso!", 3)
        -- Comando para recarregar legendas no MPV
        mp.command("rescan_external_files")
    else
        mp.msg.error("Erro ao baixar legenda: " .. (error or "Exit code " .. result.status))
        mp.osd_message("Falha ao baixar legenda.", 3)
    end
end

-- Função principal
local function download_subs()
    local path = mp.get_property("path")
    
    -- Validação básica: não tentar baixar para streams ou sem arquivo
    if not path or string.find(path, "^http") or string.find(path, "^ytdl") then
        mp.osd_message("Não é possível baixar (stream ou sem arquivo).", 3)
        return
    end

    -- Garante que o caminho seja absoluto para o subliminal encontrar o arquivo
    local working_directory = mp.get_property("working-directory") or ""
    local filepath = utils.join_path(working_directory, path)

    -- Verifica se o executável do subliminal existe e é acessível
    if not utils.file_info(EXECUTABLE) then
        mp.osd_message("Erro: Subliminal não encontrado!", 4)
        mp.msg.error("O arquivo do subliminal não foi encontrado em: " .. EXECUTABLE)
        return
    end

    mp.osd_message("Buscando legenda para: " .. LANGUAGE .. "...", 30)
    mp.msg.info("Iniciando download de legenda para: " .. filepath)

    -- Montagem do comando
    local args = {
        name = "subprocess",
        args = {EXECUTABLE, "download", "-l", LANGUAGE, filepath},
        capture_stdout = true,
        capture_stderr = true
    }

    -- Execução assíncrona para não travar o player
    mp.command_native_async(args, on_download_finish)
end

-- Registrar o atalho (pressione 'b' para baixar)
mp.add_forced_key_binding("b", "download_subs_key", download_subs)
mp.msg.info("--- Script autosubs carregado. Pressione 'b'. ---")
