#!/usr/bin/env bash
#
# ========================================================================================
#
# Autores:       Federico Vecchio (Vecna)
#                Fernando Souza https://github.com/tuxslack / https://www.youtube.com/@fernandosuporte
# Data:          17/11/2025
# Versão:        1.1
# Script:        acao_font-installer.sh
# Licença:       MIT
# Descrição:     Fonts Installer
#
#                https://www.pling.com/p/1007676
#                
#                
#
# Uso:           acao_font-installer.sh file.ttf
#                
#
#
# Requisitos:    bash, yad, fc-cache
# 
#
# ========================================================================================

clear

logo="/usr/share/icons/extras/fonts.jpg"

# ---------------------
# Linguagem automática
# ---------------------

# Function to set language strings based on the system's language

set_language_strings() {

    case "$LANG" in

        it_IT* ) # Italian
            ok='Installazione font(s) completata.'
            title_ok='Font Installer'
            title_wait='Aggiornamento'
            wait='Aggiornamento lista font in corso...'
            errors='Si sono verificati degli errori'
            title_errors='Errore'
            copying_fonts='Copia dei font in corso...'
            yad_not_installed="Il programma Yad non è installato."
            invalid_source_file="Non è stato selezionato alcun file sorgente valido."
            ;;

        fr_FR* ) # French
            ok='Installation des polices terminée.'
            title_ok='Installateur de polices'
            title_wait='Mise à jour'
            wait='Mise à jour de la liste des polices...'
            errors='Des erreurs se sont produites'
            title_errors='Erreur'
            copying_fonts='Copie des polices en cours...'
            yad_not_installed="Le programme Yad n'est pas installé."
            invalid_source_file="Aucun fichier source valide n'a été sélectionné."
            ;;

        es_ES* ) # Spanish
            ok='Instalación de fuentes completada.'
            title_ok='Instalador de Fuentes'
            title_wait='Actualización'
            wait='Actualizando lista de fuentes...'
            errors='Se produjeron errores'
            title_errors='Error'
            copying_fonts='Copiando fuentes en progreso...'
            yad_not_installed="El programa Yad no está instalado."
            invalid_source_file="No se ha seleccionado ningún archivo fuente válido."
            ;;

        de_DE* ) # German
            ok='Schriftarten-Installation abgeschlossen.'
            title_ok='Schriftarten-Installer'
            title_wait='Aktualisierung'
            wait='Aktualisierung der Schriftartenliste...'
            errors='Es traten Fehler auf'
            title_errors='Fehler'
            copying_fonts='Kopiere Schriftarten...'
            yad_not_installed="Das Yad-Programm ist nicht installiert."
            invalid_source_file="Es wurde keine gültige Quelldatei ausgewählt."
            ;;

        pt_PT* ) # Portuguese
            ok='Instalação de fontes concluída.'
            title_ok='Instalador de Fontes'
            title_wait='Atualização'
            wait='Atualizando lista de fontes...'
            errors='Ocorreram erros'
            title_errors='Erro'
            copying_fonts='Copiando fontes em andamento...'
            yad_not_installed="Programa Yad não esta instalado."
            invalid_source_file="Nenhum arquivo de fonte válido foi selecionado."
            ;;

        pt_BR* ) # Brazilian Portuguese
            ok='Instalação de fontes concluída.'
            title_ok='Instalador de Fontes'
            title_wait='Atualização'
            wait='Atualizando lista de fontes...'
            errors='Ocorreram erros'
            title_errors='Erro'
            copying_fonts='Copiando fontes em andamento...'
            yad_not_installed="Programa Yad não esta instalado."
            invalid_source_file="Nenhum arquivo de fonte válido foi selecionado."
            ;;

        * ) # Default to English if system language not matched
            ok='Font(s) installation completed.'
            title_ok='Font Installer'
            title_wait='Updating'
            wait='Updating font list...'
            errors='Errors occurred'
            title_errors='Error'
            copying_fonts='Copying fonts in progress...'
            yad_not_installed="The Yad program is not installed."
            invalid_source_file="No valid source file was selected."
            ;;
    esac
}


# ----------------------------------------------------------------------------------------

# Verificar se os programas estão instalados


which yad  1> /dev/null  2> /dev/null || { echo "$yad_not_installed"   ; exit ; }

# ----------------------------------------------------------------------------------------


# ---------------------
# Criar diretório
# ---------------------

create_dir() {

    [ -d "$HOME/.fonts" ] || mkdir -p "$HOME/.fonts"

}

# ---------------------
# Copiar fontes com progresso
# ---------------------

install_fonts() {

    valid_files=()

    # --- Verificação dos arquivos recebidos ---

    for file in "$@"; do
        case "${file,,}" in
            *.ttf|*.otf|*.ttc|*.woff|*.woff2)
                valid_files+=("$file")
                ;;
        esac
    done

    # Se nenhum arquivo válido foi encontrado, exibe erro

    if (( ${#valid_files[@]} == 0 )); then
        yad --center --window-icon="$logo" --error \
            --title="$title_error" \
            --text="$invalid_source_file" \
            --buttons-layout="center" \
            --button="OK:0" \
            2>/dev/null

        exit 1

    fi

    # --- Processo de instalação com barra de progresso ---

    total=${#valid_files[@]}
    count=0

    (
    for file in "${valid_files[@]}"; do
        mv "$file" "$HOME/.fonts"
        count=$((count+1))
        echo $((count * 100 / total))
        sleep 0.1
    done
    ) | yad --center --progress --window-icon="$logo" \
        --title="$title" \
        --text="$copying" \
        --percentage=0 \
        --auto-close \
        --buttons-layout="center" \
        --button="OK:0" \
        --width="500" --height="100" 2>/dev/null
}


# ---------------------
# Atualizar cache
# ---------------------

update_cache() {
    (
      fc-cache -fv
      echo "100"
    ) | yad --center --progress --window-icon "$logo" --title="$title" --text="$updating" --percentage=0 --auto-close --buttons-layout="center" --button="OK:0" --width="500" --height="100" 2>/dev/null
}

# ---------------------
# MAIN
# ---------------------

set_language_strings
create_dir
install_fonts "$@"
update_cache

yad --center --info --window-icon "$logo" --title="$title" --text="$ok" --buttons-layout="center" --button="OK:0" 2> /dev/null

exit 0

