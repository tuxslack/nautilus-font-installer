#!/usr/bin/env bash
#
# ========================================================================================
#
# Authors:       Federico Vecchio (Vecna) https://github.com/ziovec/nautilus-font-installer | ziovecna@gmail.com
#                Fernando Souza           https://github.com/tuxslack/font-installer        | https://www.youtube.com/@fernandosuporte
#
# Date:          17/11/2025
# Version:       2.1
# Script:        acao_font-installer.sh
# License:       GPL-3.0
# Description:   Fonts Installer
#
#                https://www.pling.com/p/1007676
#                
#
# Installation:
#
#                sudo mv usr /   or  sudo mv -i acao_font-installer.sh /usr/local/bin/
#
#                sudo chmod +x /usr/local/bin/acao_font-installer.sh
#
#
# ----------------------------------------------------------------------------------------
#
# Xfce (configure)
#
# mkdir -p ~/.config/Thunar/
#
# nano ~/.config/Thunar/uca.xml
#
# <action>
# 	<icon>/usr/share/icons/extras/fonts.jpg</icon>
# 	<name>Instalar Fonte</name>
# 	<submenu></submenu>
# 	<unique-id>1763354524864721-1</unique-id>
# 	<command>/usr/local/bin/acao_font-installer.sh %F</command>
# 	<description>Instalar fonte em ~/.fonts</description>
# 	<range>*</range>
# 	<patterns>*.ttf;*.otf;*.ttc;*.woff;*.woff2;*.pfb;*.pfa;*.pfm;*.afm;*.otc;*.bdf;*.pcf;*.snf</patterns>
# 	<other-files/>
# </action>
#
# Encerra qualquer instância do Thunar em execução.
#
# thunar -q
#
# ----------------------------------------------------------------------------------------
# 
# Gnome (configure)
#
# mkdir -p ~/.local/share/nautilus/scripts
#
# ln -sf /usr/local/bin/acao_font-installer.sh ~/.local/share/nautilus/scripts/
#
# Finaliza todas as instâncias do Nautilus que estão rodando.
#
# nautilus -q
#
# ----------------------------------------------------------------------------------------
#
# How to use:           
#                acao_font-installer.sh file.ttf file1.ttf file2.ttf 
#                
#
#
# Requirements:  bash, yad, fc-list, fc-cache, zip, mv
# 
#
# ========================================================================================


# Websites for downloading font files:

# https://www.dafontfree.co/
# https://www.wfonts.com/
# https://fontmeme.com/
# https://www.dafont.com/pt/
# https://fonts.google.com/
# https://allbestfonts.com/
# https://en.bestfonts.pro/


clear

# Arquivo de imagem

logo="/usr/share/icons/extras/fonts.jpg"


# -----------------------
# Configurações de idioma
# -----------------------


# ls /usr/share/locale/


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
            updatecachefonts="Aggiornamento della cache dei caratteri in corso..."
            message1="Errore"
            message2="I seguenti comandi non sono installati"
            message3="Tutti i comandi sono presenti."
            message4="Il carattere %s è già installato, lo sto ignorando..."
            message5="Installazione di %s..."

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
            updatecachefonts="Mise à jour du cache des polices..."
            message1="Erreur"
            message2="Les commandes suivantes ne sont pas installées"
            message3="Toutes les commandes sont présentes."
            message4="Police %s déjà installée, ignorant..."
            message5="Installation de %s..."

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
            updatecachefonts="Actualizando caché de fuentes..."
            message1="Error"
            message2="Los siguientes comandos no están instalados"
            message3="Todos los comandos están presentes."
            message4="La fuente %s ya está instalada, ignorando..."
            message5="Instalando %s..."

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
            updatecachefonts="Schriftart-Cache wird aktualisiert..."
            message1="Fehler"
            message2="Die folgenden Befehle sind nicht installiert"
            message3="Alle Befehle sind vorhanden."
            message4="Schriftart %s bereits installiert, ignoriert..."
            message5="%s wird installiert..."
 
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
            updatecachefonts="Atualizando o cache de fontes..."
            message1="Erro"
            message2="Os seguintes comandos não estão instalados"
            message3="Todos os comandos estão presentes."
            message4="Fonte %s já instalada, ignorando..."
            message5="Instalando %s..."

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
            updatecachefonts="Atualizando o cache de fontes..."
            message1="Erro"
            message2="Os seguintes comandos não estão instalados"
            message3="Todos os comandos estão presentes."
            message4="Fonte %s já instalada, ignorando..."
            message5="Instalando %s..."

            ;;

        ru_RU* ) # Russian

            ok='Установка шрифтов завершена.'
            title_ok='Установщик шрифтов'
            title_wait='Обновить'
            wait='Обновление списка шрифтов...'
            errors='Произошли ошибки'
            title_errors='Ошибка'
            copying_fonts='Идет копирование шрифтов...'
            yad_not_installed="Программа Yad не установлена."
            invalid_source_file="Не выбран допустимый файл шрифта."
            updatecachefonts="Обновление кэша шрифтов..."
            message1="Ошибка"
            message2="Следующие команды не установлены"
            message3="Все команды присутствуют."
            message4="Шрифт %s уже установлен, игнорируется..."
            message5="Установка %s..."

            ;;

        uk* ) # Ukrainian

            ok='Встановлення шрифту(ів) завершено.'
            title_ok='Інсталятор шрифтів'
            title_wait='Оновлення'
            wait='Оновлення списку шрифтів...'
            errors='Сталися помилки'
            title_errors='Помилка'
            copying_fonts='Триває копіювання шрифтів...'
            yad_not_installed="Програму Yad не встановлено."
            invalid_source_file="Не вибрано дійсний вихідний файл."
            updatecachefonts="Оновлення кешу шрифтів..."
            message1="Помилка"
            message2="Наступні команди не встановлено"
            message3="Усі команди присутні."
            message4="Шрифт %s вже встановлено, ігнорується..."
            message5="Встановлення %s..."

            ;;

        ko* ) # Korean

            ok='글꼴 설치가 완료되었습니다.'
            title_ok='글꼴 설치 프로그램'
            title_wait='업데이트 중'
            wait='글꼴 목록 업데이트 중...'
            errors='오류 발생'
            title_errors='오류'
            copying_fonts='글꼴 복사 중...'
            yad_not_installed="Yad 프로그램이 설치되지 않았습니다."
            invalid_source_file="유효한 원본 파일을 선택하지 않았습니다."
            updatecachefonts="글꼴 캐시 업데이트 중..."
            message1="오류"
            message2="다음 명령이 설치되지 않았습니다."
            message3="모든 명령이 존재합니다."
            message4="%s 글꼴이 이미 설치되었습니다. 무시합니다..."
            message5="%s 설치 중..."

            ;;

        ja* ) # Japanese

            ok='フォントのインストールが完了しました'
            title_ok='フォントインストーラ'
            title_wait='更新中'
            wait='フォントリストを更新しています...'
            errors='エラーが発生しました'
            title_errors='エラー'
            copying_fonts='フォントのコピー中...'
            yad_not_installed="Yad プログラムがインストールされていません"
            invalid_source_file="有効なソースファイルが選択されていません"
            updatecachefonts="フォントキャッシュを更新しています..."
            message1="エラー"
            message2="以下のコマンドがインストールされていません"
            message3="すべてのコマンドが存在します"
            message4="フォント %s は既にインストールされています。無視します..."
            message5="%s をインストールしています..."

            ;;

        zh_CN* ) # Chinese from mainland China (simplified Mandarin)

            ok='字体安装完成'
            title_ok='字体安装程序'
            title_wait='正在更新'
            wait='正在更新字体列表...'
            errors='发生错误'
            title_errors='错误'
            copying_fonts='正在复制字体...'
            yad_not_installed="Yad 程序未安装"
            invalid_source_file="未选择有效的源文件"
            updatecachefonts="正在更新字体缓存..."
            message1="错误"
            message2="以下命令未安装"
            message3="所有命令均已安装"
            message4="字体 %s 已安装，忽略..."
            message5="正在安装 %s..."

            ;;

        zh_Hant* ) # Traditional Chinese (generally used in Taiwan and Hong Kong)

            ok='字型安裝完成'
            title_ok='字型安裝程式'
            title_wait='正在更新'
            wait='正在更新字體列表...'
            errors='發生錯誤'
            title_errors='錯誤'
            copying_fonts='正在複製字體...'
            yad_not_installed="Yad 程式未安裝"
            invalid_source_file="未選擇有效的來源檔案"
            updatecachefonts="正在更新字體快取..."
            message1="錯誤"
            message2="以下命令未安裝"
            message3="所有指令均已安裝"
            message4="字型 %s 已安裝，忽略..."
            message5="正在安裝 %s..."

            ;;

        en_US* ) # English

            ok='Font(s) installation completed.'
            title_ok='Font Installer'
            title_wait='Updating'
            wait='Updating font list...'
            errors='Errors occurred'
            title_errors='Error'
            copying_fonts='Copying fonts in progress...'
            yad_not_installed="The Yad program is not installed."
            invalid_source_file="No valid source file was selected."
            updatecachefonts="Updating font cache..."
            message1="Error"
            message2="The following commands are not installed"
            message3="All commands are present."
            message4="Font %s already installed, ignoring..."
            message5="Installing %s..."

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
            updatecachefonts="Updating font cache..."
            message1="Error"
            message2="The following commands are not installed"
            message3="All commands are present."
            message4="Font %s already installed, ignoring..."
            message5="Installing %s..."

            ;;
    esac
}


# ----------------------------------------------------------------------------------------

# Verificar se os programas estão instalados


check_programs(){


which yad  1> /dev/null  2> /dev/null || { echo "$yad_not_installed"   ; exit ; }




# Lista de comandos para verificar

comandos="mv cp fc-list fc-cache zip"

# Variável para armazenar comandos ausentes

faltando=""

# Verifica cada comando

for cmd in $comandos; do

    if ! command -v $cmd >/dev/null 2>&1; then

        faltando="$faltando $cmd"

    fi

done



# Se algum comando estiver faltando, mostra aviso via yad

if [ -n "$faltando" ]; then

    if command -v yad >/dev/null 2>&1; then
        yad --title="$message1" \
            --text="$message2: \n\n$faltando" \
            --buttons-layout="center" \
            --button="OK:0" \
            --width="500" --height="200" \
            2>/dev/null

    else

        # fallback para terminal

        echo -e "$message2: \n\n$faltando \n"

    fi

    exit 1

fi

# Se tudo estiver instalado

echo -e "\n$message3\n"


}

# ----------------------------------------------------------------------------------------


# ---------------------
# Criar diretório
# ---------------------

create_dir() {

    [ -d "$HOME/.fonts" ] || mkdir -p "$HOME/.fonts"

}

# -----------------------------
# Movendo fontes com progresso
# -----------------------------


# Usar fc-list | grep <nome_da_fonte> é a forma mais confiável de verificar se a fonte já 
# está registrada no sistema, não apenas se o arquivo existe no $HOME/.fonts. Isso evita 
# que você instale duplicatas de fontes que já estão disponíveis globalmente (em 
# /usr/share/fonts ou em outra pasta de sistema).

install_fonts() {

    valid_files=()


    # --- Verificação dos arquivos recebidos ---


# 📂 Podem ser instaladas em /usr/share/fonts ou ~/.fonts e vão funcionar:

# ✔ .pfb
# ✔ .pfa
# ✔ .pfm
# ✔ .afm
# ✔ .otc
# ✔ .bdf
# ✔ .pcf
# ✔ .snf

# 📂 Funcionam com limitações:

# 🟡 .dfont
# 🟡 .fnt
# 🟡 .fon
# 🟡 .suit

# 📂 NÃO funcionam no Linux como fontes do sistema:

# ⛔ .svg
# ⛔ .eot


# Obs: Converter formatos incompatíveis para .ttf ou .otf


    # Filtra arquivos válidos

    for file in "$@"; do

        case "${file,,}" in
            *.ttf|*.otf|*.ttc|*.woff|*.woff2|*.pfb|*.pfa|*.pfm|*.afm|*.otc|*.bdf|*.pcf|*.snf)
                valid_files+=("$file")
                ;;
        esac

    done


    # Se nenhum arquivo válido foi encontrado, exibe erro

    if (( ${#valid_files[@]} == 0 )); then

        yad --center \
            --window-icon="$logo" \
            --error \
            --title="$title_errors" \
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

        basefile=$(basename "$file")
        
        # Verifica se a fonte já está registrada no sistema

        if fc-list | grep -iq "$basefile"; then
            
            echo "# $(printf "$message4" "$basefile")"

            sleep 1

        else

            # É uma questão de preferência pessoal, mas eu prefiro move as fontes em vez 
            # de copia-las. Por isso, precisei trocar "cp" por "mv".

            mv "$file" "$HOME/.fonts"

            echo "# $(printf "$message5" "$basefile")"

        fi

        count=$((count+1))

        echo $((count * 100 / total))

        sleep 0.1

    done
    ) | yad \
        --center \
        --progress \
        --window-icon="$logo" \
        --title="$title_ok" \
        --text="$copying_fonts" \
        --percentage=0 \
        --auto-close \
        --buttons-layout="center" \
        --button="OK:0" \
        --width="500" --height="100" \
        2>/dev/null
}




# ---------------------
# Atualizar cache
# ---------------------

update_cache() {


# Você deve rodar fc-cache -fv quando:

# ✔ Instala novas fontes manualmente
# ✔ Remove fontes
# ✔ Move fontes para outros diretórios (/usr/share/fonts, ~/.fonts, /usr/local/share/fonts, etc.)
# ✔ Algum software não reconhece fontes recém-instaladas


echo -e "\n$updatecachefonts \n"

# Contar quantas fontes existem e processar uma a uma.

total=$(fc-list | wc -l)
count=0

# Reconstrói o cache de fontes usado pelo sistema para localizar e carregar fontes mais 
# rapidamente.

fc-cache -fv | while read line; do
    count=$((count+1))
    percent=$((count*100/total))
    echo "$percent"
    echo "# $line"
done | yad \
    --center \
    --progress \
    --window-icon="$logo" \
    --title="$updatecachefonts" \
    --text="$updating" \
    --percentage=0 \
    --auto-close --auto-kill \
    --buttons-layout=center \
    --button="OK:0" \
    --width="500" --height="100" 

}

# ---------------------
# MAIN
# ---------------------


set_language_strings
check_programs
create_dir
install_fonts "$@"
update_cache

yad --center --info --window-icon "$logo" --title="$title_ok" --text="$ok" --buttons-layout="center" --button="OK:0" --width="300" --height="100"  2> /dev/null

exit 0

