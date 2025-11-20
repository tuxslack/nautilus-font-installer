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
# License:       GPL-2.0
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

# No LabWC o YAD não encontra a imagem apontada por $logo.

logo="/usr/share/icons/extras/fonts.jpg"




# -----------------------
# Configurações de idioma
# -----------------------


# ls /usr/share/locale/


# Function to set language strings based on the system's language

set_language_strings() {


# O símbolo | significa "OU"


    case "$LANG" in

        it_IT* ) # Italian / Italiano

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

        fr_FR* ) # French / Francês

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

        es_ES*|es ) # 🇪🇸 Spanish / Espanhol

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


        de_DE*|de ) # 🇩🇪 German / Alemão

            # O shell expande os padrões para evitar problemas.

            # de → geralmente significa alemão genérico, que em quase todos os sistemas equivale ao padrão de_DE.

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

        pt_PT* ) # 🇵🇹 Portuguese / Português

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

        pt_BR* ) # 🇧🇷 Brazilian Portuguese / Português brasileiro

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

        ru_RU* ) # 🇷🇺 Russian / Русский / Russo

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

        uk_UA*|uk ) # Ukrainian / Ucraniano

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

        ko* ) # Korean / Coreano

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

        ja* ) # Japanese / Japonês

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

        zh_CN* ) # Chinese from mainland China (simplified Mandarin) / Chinês

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

        zh_Hant* ) # Traditional Chinese (generally used in Taiwan and Hong Kong) / Chinês

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

        pl_PL*|pl ) # 🇵🇱 Polish / Polonês

            ok='Instalacja czcionek zakończona.'
            title_ok='Instalator czcionek'
            title_wait='Aktualizacja'
            wait='Aktualizowanie listy czcionek...'
            errors='Wystąpiły błędy'
            title_errors='Błąd'
            copying_fonts='Trwa kopiowanie czcionek...'
            yad_not_installed="Program Yad nie jest zainstalowany."
            invalid_source_file="Nie wybrano prawidłowego pliku źródłowego."
            updatecachefonts="Aktualizowanie pamięci podręcznej czcionek..."
            message1="Błąd"
            message2="Następujące polecenia nie zostały zainstalowane."
            message3="Wszystkie polecenia są obecne."
            message4="Czcionka %s jest już zainstalowana, ignoruję..."
            message5="Instalowanie %s..."

            ;;

        hu_HU*|hu ) # 🇭🇺 Hungarian / Húngaro

            ok='Betűtípus(ok) telepítése befejeződött.'
            title_ok='Betűtípustelepítő'
            title_wait='Frissítés'
            wait='Betűtípuslista frissítése...'
            errors="Hiba történt'"
            title_errors='Hiba'
            copying_fonts='Betűtípusok másolása folyamatban...'
            yad_not_installed="A Yad program nincs telepítve."
            invalid_source_file="Nincs érvényes forrásfájl kiválasztva."
            updatecachefonts="Betűtípus-gyorsítótár frissítése..."
            message1="Hiba"
            message2="A következő parancsok nincsenek telepítve"
            message3="Minden parancs jelen van."
            message4="A(z) %s betűtípus már telepítve van, figyelmen kívül hagyva..."
            message5="%s telepítése..."

            ;;

        tr_TR*|tr ) # Turkish / Turco

            ok='Yazı tipi(leri) kurulumu tamamlandı.'
            title_ok='Yazı Tipi Yükleyici'
            title_wait='Güncelleniyor'
            wait='Yazı tipi listesi güncelleniyor...'
            errors='Hatalar oluştu'
            title_errors='Hata'
            copying_fonts='Yazı tipleri kopyalanıyor...'
            yad_not_installed="Yad programı kurulu değil."
            invalid_source_file="Geçerli bir kaynak dosyası seçilmedi."
            updatecachefonts="Yazı tipi önbelleği güncelleniyor..."
            message1="Hata"
            message2="Aşağıdaki komutlar kurulu değil"
            message3="Tüm komutlar mevcut."
            message4="%s yazı tipi zaten kurulu, yoksayılıyor..."
            message5="%s kuruluyor..."

            ;;

        sk_SK*|sk ) # 🇸🇰 Slovak / Eslovaco (Eslováquia)

            ok='Namestitev pisave(-e) je končana.'
            title_ok='Namestitveni program za pisave'
            title_wait='Posodabljanje'
            wait='Posodabljanje seznama pisav...'
            errors='Prišlo je do napak'
            title_errors='Napaka'
            copying_fonts='Kopiranje pisav je v teku...'
            yad_not_installed="Program Yad ni nameščen."
            invalid_source_file="Izbrana ni bila nobena veljavna izvorna datoteka."
            updatecachefonts="Posodabljanje predpomnilnika pisav..."
            message1="Napaka"
            message2="Naslednji ukazi niso nameščeni"
            message3="Vsi ukazi so prisotni."
            message4="Pisava %s je že nameščena, ignoriranje..."
            message5="Nameščanje %s..."

            ;;

        el ) # Greek / Grego

            ok='Η εγκατάσταση γραμματοσειρών ολοκληρώθηκε.'
            title_ok='Πρόγραμμα εγκατάστασης γραμματοσειρών'
            title_wait='Ενημέρωση'
            wait='Ενημέρωση λίστας γραμματοσειρών...'
            errors='Παρουσιάστηκαν σφάλματα'
            title_errors='Σφάλμα'
            copying_fonts='Αντιγραφή γραμματοσειρών σε εξέλιξη...'
            yad_not_installed="Το πρόγραμμα Yad δεν είναι εγκατεστημένο."
            invalid_source_file="Δεν επιλέχθηκε έγκυρο αρχείο προέλευσης."
            updatecachefonts="Ενημέρωση προσωρινής μνήμης γραμματοσειρών..."
            message1="Σφάλμα"
            message2="Οι ακόλουθες εντολές δεν είναι εγκατεστημένες"
            message3="Υπάρχουν όλες οι εντολές."
            message4="Η γραμματοσειρά %s έχει ήδη εγκατασταθεί, αγνοείται..."
            message5="Εγκατάσταση %s..."

            ;;

        ga ) # Irish / Irlandês

            ok='Suiteáil cló(nna) críochnaithe.'
            title_ok='Suiteálaí Clónna'
            title_wait='Ag Nuashonrú'
            wait='Liosta clónna á nuashonrú...'
            errors='Tharla earráidí'
            title_errors='Earráid'
            copying_fonts='Clónna á gcóipeáil ar siúl...'
            yad_not_installed="Níl an clár Yad suiteáilte."
            invalid_source_file="Níor roghnaíodh comhad foinse bailí."
            updatecachefonts="Taisce clónna á nuashonrú..."
            message1="Earráid"
            message2="Níl na horduithe seo a leanas suiteáilte"
            message3="Tá na horduithe go léir i láthair."
            message4="Cló %s suiteáilte cheana féin, ag déanamh neamhaird..."
            message5="Ag suiteáil %s..."

            ;;


        ro ) # Romanian / Romeno

            ok='Instalarea fontului(elor) finalizată.'
            title_ok='Program de instalare fonturi'
            title_wait='Actualizare'
            wait='Actualizare listă fonturi...'
            errors='Au apărut erori'
            title_errors='Eroare'
            copying_fonts='Copierea fonturilor este în curs...'
            yad_not_installed="Programul Yad nu este instalat."
            invalid_source_file="Nu a fost selectat niciun fișier sursă valid."
            updatecachefonts="Actualizare memorie cache fonturi..."
            message1="Eroare"
            message2="Următoarele comenzi nu sunt instalate"
            message3="Toate comenzile sunt prezente."
            message4="Fontul %s este deja instalat, se ignoră..."
            message5="Se instalează %s..."

            ;;

        ab ) # Abecásio

            ok='Ашрифт(қәа) рышьақәыргылара хыркәшоуп.'
            title_ok='Ашрифт ақәыргылаҩ'
            title_wait='Арҿыцра'
            wait='Ашрифтқәа рсиа арҿыцра...'
            errors="Агха ҟалеит'"
            title_errors='Агха'
            copying_fonts='Ашрифтқәа рықәҭыхра мҩаԥысуеит...'
            yad_not_installed="Апрограмма Яд шьақәыргылаӡам."
            invalid_source_file="Ииашоу ахыҵхырҭатә фаил алхмызт."
            updatecachefonts="Ашрифт ақәҵа арҿыцра..."
            message1="Агха"
            message2="Абарҭ адҵақәа шьақәыргылаӡам"
            message3="Адҵақәа зегьы ыҟоуп."
            message4="Ашрифт %s шьақәыргылоуп, хьаас иҟамҵакәа..."
            message5="Ашьақәыргылара %s..."

            ;;

        ar ) # Arabic / Árabe

            ok='تم تثبيت الخطوط.'
            title_ok='مُثبّت الخطوط'
            title_wait='جاري التحديث'
            wait='جاري تحديث قائمة الخطوط...'
            errors='حدثت أخطاء'
            title_errors='خطأ'
            copying_fonts='جاري نسخ الخطوط...'
            yad_not_installed="برنامج Yad غير مُثبّت."
            invalid_source_file="لم يتم تحديد ملف مصدر صالح."
            updatecachefonts="جاري تحديث ذاكرة التخزين المؤقت للخطوط..."
            message1="خطأ"
            message2="الأوامر التالية غير مُثبّتة."
            message3="جميع الأوامر موجودة."
            message4="الخط %s مُثبّت بالفعل، جارٍ تجاهل..."
            message5="جاري تثبيت %s..."

            ;;

        bo ) # Tibetan / Tibetano

            ok='ཡིག་གཟུགས་སྒྲིག་འཇུག་མཇུག་སྒྲིལ་ཡོད།'
            title_ok='ཡིག་གཟུགས་སྒྲིག་འཇུག་བྱེད་མཁན།'
            title_wait='གསར་བཅོས་བྱེད་བཞིན་པ།'
            wait='ཡིག་གཟུགས་རེའུ་མིག་གསར་བཅོས་བྱེད་པ།...'
            errors='ནོར་འཁྲུལ་བྱུང་བ།'
            title_errors='ནོར་འཁྲུལ'
            copying_fonts='ཡིག་གཟུགས་འདྲ་བཤུས་བྱེད་བཞིན་པ།'
            yad_not_installed="ཡ་ཌི་ལས་རིམ་སྒྲིག་འཇུག་བྱས་མེད།"
            invalid_source_file="ནུས་ལྡན་གྱི་ཐོན་ཁུངས་ཡིག་ཆ་འདེམས་མེད།"
            updatecachefonts="ཡིག་གཟུགས་ཀྱི་མཛོད་གསར་བཅོས་བྱེད་བཞིན་ཡོད།"
            message1="ནོར་འཁྲུལ"
            message2="གཤམ་གྱི་བཀའ་ཚིག་སྒྲིག་འཇུག་བྱས་མེད།"
            message3="བཀའ་ཚིག་ཚང་མ་ཡོད།"
            message4="ཡིག་གཟུགས་ %s སྔོན་ནས་སྒྲིག་འཇུག་བྱས་ཟིན།"
            message5='%s སྒྲིག་འཇུག་བྱེད་བཞིན་ཡོད།...'

            ;;

        bg ) # Bulgarian / Búlgaro

            ok='Инсталирането на шрифт(ове) е завършено.'
            title_ok='Инсталатор на шрифтове'
            title_wait='Актуализиране'
            wait='Актуализиране на списъка с шрифтове...'
            errors='Възникнаха грешки'
            title_errors='Грешка'
            copying_fonts='Копиране на шрифтове в процес...'
            yad_not_installed="Програмата Yad не е инсталирана."
            invalid_source_file="Не е избран валиден изходен файл."
            updatecachefonts="Актуализиране на кеша на шрифтове..."
            message1="Грешка"
            message2="Следните команди не са инсталирани"
            message3="Всички команди са налични."
            message4="Шрифт %s вече е инсталиран, игнорира се..."
            message5="Инсталиране на %s..."

            ;;

        da ) # Dinamarquês

            ok='Installation af skrifttype(r) er fuldført.'
            title_ok='Skrifttypeinstallationsprogram'
            title_wait='Opdaterer'
            wait='Opdaterer skrifttypeliste...'
            errors='Der opstod fejl'
            title_errors='Fejl'
            copying_fonts='Kopiering af skrifttyper i gang...'
            yad_not_installed="Yad-programmet er ikke installeret."
            invalid_source_file="Der blev ikke valgt nogen gyldig kildefil."
            updatecachefonts="Opdaterer skrifttypecache..."
            message1="Fejl"
            message2="Følgende kommandoer er ikke installeret"
            message3="Alle kommandoer er til stede."
            message4="Skrifttype %s er allerede installeret, ignorerer..."
            message5="Installerer %s..."

            ;;

        yo ) # Iorubá

            ok='Fifi sori Font(s) ti pari.'
            title_ok='Olùfi sori Font'
            title_wait='Nmu dojuiwọn'
            wait='Nmu akojọ awọn fonti ṣe imudojuiwọn...'
            errors="Awọn aṣiṣe waye'"
            title_errors='Aṣiṣe'
            copying_fonts='Ṣiṣakọ awọn fonti n lọ lọwọ...'
            yad_not_installed="Eto Yad ko si."
            invalid_source_file="Ko si faili orisun to wulo ti a yan."
            updatecachefonts="Nmu awọn kaṣe fonti ṣe imudojuiwọn..."
            message1="Aṣiṣe"
            message2="Awọn aṣẹ wọnyi ko si sori ẹrọ"
            message3="Gbogbo awọn aṣẹ wa."
            message4="Font %s ti fi sori ẹrọ tẹlẹ, aibikita..."
            message5="Nfi %s sori ẹrọ..."

            ;;

        nl ) # Dutch / Holandês

            ok='Installatie van lettertype(n) voltooid.'
            title_ok='Lettertype-installatieprogramma'
            title_wait='Bijwerken'
            wait='Lettertypelijst bijwerken...'
            errors='Er zijn fouten opgetreden'
            title_errors='Fout'
            copying_fonts='Lettertypen kopiëren bezig...'
            yad_not_installed="Het Yad-programma is niet geïnstalleerd."
            invalid_source_file="Er is geen geldig bronbestand geselecteerd."
            updatecachefonts="Lettertypecache bijwerken..."
            message1="Fout"
            message2="De volgende opdrachten zijn niet geïnstalleerd"
            message3="Alle opdrachten zijn aanwezig."
            message4="Lettertype %s is al geïnstalleerd, negeren..."
            message5="%s installeren..."

            ;;

        cy ) # Welsh / Galês

            ok="Gosod ffont(iau) wedi'i gwblhau."
            title_ok='Gosodwr Ffontiau'
            title_wait='Diweddaru'
            wait='Diweddaru rhestr ffontiau...'
            errors='Digwyddodd gwallau'
            title_errors='Gwall'
            copying_fonts='Copïo ffontiau ar y gweill...'
            yad_not_installed="Nid yw'r rhaglen Yad wedi'i gosod."
            invalid_source_file="Ni ddewiswyd ffeil ffynhonnell ddilys."
            updatecachefonts="Diweddaru storfa ffontiau..."
            message1="Gwall"
            message2="Nid yw'r gorchmynion canlynol wedi'u gosod"
            message3="Mae pob gorchymyn yn bresennol."
            message4="Ffont %s eisoes wedi'i osod, yn anwybyddu..."
            message5="Gosod %s..."

            ;;

        nn_NO*|nn ) # Norwegian / Norueguês (Noruega)

            ok='Installasjon av skrift(er) fullført.'
            title_ok='Skriftinstallasjonsprogram'
            title_wait='Oppdaterer'
            wait='Oppdaterer skriftliste...'
            errors='Det oppsto feil'
            title_errors='Feil'
            copying_fonts='Kopiering av skrifttyper pågår...'
            yad_not_installed="Yad-programmet er ikke installert."
            invalid_source_file="Ingen gyldig kildefil ble valgt."
            updatecachefonts="Oppdaterer skriftbuffer..."
            message1="Feil"
            message2="Følgende kommandoer er ikke installert"
            message3="Alle kommandoer er tilgjengelige."
            message4="Skrift %s er allerede installert, ignorerer..."
            message5="Installerer %s..."

            ;;

	
        vi ) # Vietnamese / Vietnamita

            ok='Đã hoàn tất cài đặt phông chữ.'
            title_ok='Trình cài đặt phông chữ'
            title_wait='Đang cập nhật'
            wait='Đang cập nhật danh sách phông chữ...'
            errors="Đã xảy ra lỗi'"
            title_errors='Lỗi'
            copying_fonts='Đang sao chép phông chữ...'
            yad_not_installed="Chương trình Yad chưa được cài đặt."
            invalid_source_file="Không chọn được tệp nguồn hợp lệ."
            updatecachefonts="Đang cập nhật bộ nhớ đệm phông chữ..."
            message1="Lỗi"
            message2="Các lệnh sau chưa được cài đặt"
            message3="Tất cả các lệnh đều có sẵn."
            message4="Phông chữ %s đã được cài đặt, đang bỏ qua..."
            message5="Đang cài đặt %s..."

            ;;

        th ) # Thai / Tailandês

            ok='การติดตั้งฟอนต์เสร็จสมบูรณ์'
            title_ok='ตัวติดตั้งฟอนต์'
            title_wait='กำลังอัปเดต'
            wait='กำลังอัปเดตรายการฟอนต์...'
            errors='เกิดข้อผิดพลาด'
            title_errors='ข้อผิดพลาด'
            copying_fonts='กำลังคัดลอกฟอนต์...'
            yad_not_installed="ยังไม่ได้ติดตั้งโปรแกรม Yad"
            invalid_source_file="ไม่ได้เลือกไฟล์ต้นฉบับที่ถูกต้อง"
            updatecachefonts="กำลังอัปเดตแคชฟอนต์..."
            message1="ข้อผิดพลาด"
            message2="ไม่ได้ติดตั้งคำสั่งต่อไปนี้"
            message3="มีคำสั่งทั้งหมด"
            message4="ฟอนต์ %s ติดตั้งแล้ว กำลังละเว้น..."
            message5="กำลังติดตั้ง %s..."

            ;;

        ce ) # Checheno

            ok='Шрифт(аш) дӀахӀоттор чекхдаьлла.'
            title_ok='Шрифт дӀахӀотторхо'
            title_wait='Карладаккхар'
            wait='Шрифтийн тептар карладаккхар...'
            errors="ГӀалаташ нисделла'."
            title_errors='ГӀалат'
            copying_fonts='Шрифташ копировать еш ю...'
            yad_not_installed="Яд программа дӀахӀоттийна яц."
            invalid_source_file="Цхьа а нийса хьостан файл ца хаьржина."
            updatecachefonts="Шрифтан кэш карлаяккхар..."
            message1="ГӀалат"
            message2="Дагахь латтаде командаш дӀа ца хӀиттийна."
            message3="Дерриге а омранаш цигахь ду."
            message4="Шрифт %s хӀинцале а хӀоттийна, тидаме ца оьцуш..."
            message5="%s дӀахӀоттор..."

            ;;

        gl ) # Galician / Galego 

            ok="Gosod ffont(iau) wedi'i gwblhau."
            title_ok='Gosodwr Ffontiau'
            title_wait='Diweddaru'
            wait='Diweddaru rhestr ffontiau...'
            errors='Digwyddodd gwallau'
            title_errors='Gwall'
            copying_fonts='Copïo ffontiau ar y gweill...'
            yad_not_installed="Nid yw'r rhaglen Yad wedi'i gosod."
            invalid_source_file="Ni ddewiswyd ffeil ffynhonnell ddilys."
            updatecachefonts="Diweddaru storfa ffontiau..."
            message1="Gwall"
            message2="Nid yw'r gorchmynion canlynol wedi'u gosod"
            message3="Mae pob gorchymyn yn bresennol."
            message4="Ffont %s eisoes wedi'i osod, yn anwybyddu..."
            message5="Gosod %s..."

            ;;

        sv ) # Swedish / Sueco

            ok='Installation av teckensnitt är slutförd.'
            title_ok='Teckensnittsinstallationsprogram'
            title_wait='Uppdaterar'
            wait='Uppdaterar teckensnittslista...'
            errors='Fel inträffade'
            title_errors='Fel'
            copying_fonts='Kopiering av teckensnitt pågår...'
            yad_not_installed="Yad-programmet är inte installerat."
            invalid_source_file="Ingen giltig källfil valdes."
            updatecachefonts="Uppdaterar teckensnittscachen..."
            message1="Fel"
            message2="Följande kommandon är inte installerade"
            message3="Alla kommandon finns."
            message4="Teckensnitt %s är redan installerat, ignorerar..."
            message5="Installerar %s..."

            ;;

        sq ) # Albanian / Albanês

            ok='Instalimi i fontit(eve) përfundoi.'
            title_ok='Instaluesi i Fontit'
            title_wait='Duke përditësuar'
            wait='Duke përditësuar listën e fonteve...'
            errors='Ndodhën gabime'
            title_errors='Gabim'
            copying_fonts='Kopjimi i fonteve është në proces...'
            yad_not_installed="Programi Yad nuk është instaluar."
            invalid_source_file="Nuk është zgjedhur asnjë skedar burimor i vlefshëm."
            updatecachefonts="Duke përditësuar memorjen e përkohshme të fontit..."
            message1="Gabim"
            message2="Komandat e mëposhtme nuk janë instaluar"
            message3="Të gjitha komandat janë të pranishme."
            message4="Fonti %s është instaluar tashmë, duke injoruar..."
            message5="Duke instaluar %s..."

            ;;

        haw ) # Hawaiian / Havaiano

            ok='Ua pau ke kau ʻana o nā hua palapala.'
            title_ok="Mea Hoʻonoho Hua Palapala"
            title_wait="Ke hoʻohou nei"
            wait="Ke hoʻohou nei i ka papa inoa hua palapala..."
            errors="Ua loaʻa nā hewa'"
            title_errors='Hewa'
            copying_fonts='Ke kope nei i nā hua palapala e holomua nei...'
            yad_not_installed="ʻAʻole i hoʻokomo ʻia ka polokalamu Yad."
            invalid_source_file="ʻAʻohe faila kumu kūpono i koho ʻia."
            updatecachefonts="Ke hoʻohou nei i ka waihona hua palapala..."
            message1="Hewa"
            message2="ʻAʻole i hoʻokomo ʻia nā kauoha aʻe"
            message3="Aia nā kauoha a pau."
            message4="Ua hoʻokomo mua ʻia ka hua palapala %s, me ka nānā ʻole..."
            message5="Ke hoʻokomo nei iā %s..."

            ;;

        he ) # Hebrew / Hebraico

            ok='התקנת הגופן/ים הושלמה.'
            title_ok='מתקין גופנים'
            title_wait='מעדכן'
            wait='מעדכן רשימת גופנים...'
            errors='אירעו שגיאות'
            title_errors='שגיאה'
            copying_fonts='העתקת גופנים מתבצעת...'
            yad_not_installed="תוכנית Yad אינה מותקנת."
            invalid_source_file="לא נבחר קובץ מקור חוקי."
            updatecachefonts="מעדכן מטמון גופנים..."
            message1="שגיאה"
            message2="הפקודות הבאות אינן מותקנות"
            message3="כל הפקודות קיימות."
            message4="הגופן %s כבר מותקן, מתעלם מ..."
            message5="מתקין %s..."

            ;;

        mn ) # Mongolian / Mongol

            ok='Фонт(ууд)-ын суулгалт дууссан.'
            title_ok='Фонт суулгагч'
            title_wait='Шинэчилж байна'
            wait='Фонтын жагсаалтыг шинэчилж байна...'
            errors='Алдаа гарлаа'
            title_errors='Алдаа'
            copying_fonts='Фонтуудыг хуулж байна...'
            yad_not_installed="Yad програм суулгаагүй байна."
            invalid_source_file="Хүчинтэй эх файл сонгогдоогүй байна."
            updatecachefonts="Фонтын кэшийг шинэчилж байна..."
            message1="Алдаа"
            message2="Дараах командууд суулгагдаагүй байна"
            message3="Бүх командууд байна."
            message4="%s фонтыг аль хэдийн суулгасан, үл тоомсорлож байна..."
            message5="%s-г суулгаж байна..."

            ;;


        hi ) # Hindi

            ok='फ़ॉन्ट इंस्टॉलेशन पूरा हो गया है।'
            title_ok='फ़ॉन्ट इंस्टॉलर'
            title_wait='अपडेट हो रहा है'
            wait='फ़ॉन्ट लिस्ट अपडेट हो रही है...'
            errors="गलतियां हुईं'"
            title_errors='गलती'
            copying_fonts='फ़ॉन्ट कॉपी हो रहे हैं...'
            yad_not_installed="Yad प्रोग्राम इंस्टॉल नहीं है।"
            invalid_source_file="कोई वैलिड सोर्स फ़ाइल नहीं चुनी गई।"
            updatecachefonts="फ़ॉन्ट कैश अपडेट हो रहा है..."
            message1="गलती"
            message2="नीचे दिए गए कमांड इंस्टॉल नहीं हैं"
            message3="सभी कमांड मौजूद हैं।"
            message4="फ़ॉन्ट %s पहले से इंस्टॉल है, अनदेखा कर रहा है..."
            message5="%s इंस्टॉल हो रहा है..."

            ;;

        la ) # Latin / Latim

            ok='Installatio fontium completa est.'
            title_ok='Installator Fontium'
            title_wait='Renovatur'
            wait='Index fontium renovatur...'
            errors='Errores facti sunt'
            title_errors='Error'
            copying_fonts='Fontes copiantur in progressu...'
            yad_not_installed="Programma Yad non installatur."
            invalid_source_file="Nullum fasciculum fontis validum selectum est."
            updatecachefonts="Cella fontium renovatur..."
            message1="Error"
            message2="Sequentia mandata non installatur."
            message3="Omnia mandata adsunt."
            message4="Fons %s iam installatur, ignoratur..."
            message5="%s installatur..."

            ;;

        fil ) # Filipino

            ok='Nakumpleto na ang pag-install ng font.'
            title_ok='Font Installer'
            title_wait='Ina-update'
            wait='Ina-update ang listahan ng font...'
            errors='May naganap na mga error'
            title_errors='Error'
            copying_fonts='Kinokopya ang mga font...'
            yad_not_installed="Hindi naka-install ang Yad program."
            invalid_source_file="Walang napiling wastong source file."
            updatecachefonts="Ina-update ang font cache..."
            message1="Error"
            message2="Hindi naka-install ang mga sumusunod na command"
            message3="Naroon ang lahat ng command."
            message4="Naka-install na ang font %s, hindi pinapansin..."
            message5="Ini-install ang %s..."

            ;;

        fa_IR*|fa ) # Persian / Persa

            ok='نصب فونت(ها) تکمیل شد.'
            title_ok='نصب‌کننده فونت'
            title_wait='در حال به‌روزرسانی'
            wait='به‌روزرسانی فهرست فونت‌ها...'
            errors='خطاهایی رخ داد'
            title_errors='خطا'
            copying_fonts='کپی کردن فونت‌ها در حال انجام است...'
            yad_not_installed="برنامه‌ی Yad نصب نشده است."
            invalid_source_file="هیچ فایل منبع معتبری انتخاب نشده است."
            updatecachefonts="در حال به‌روزرسانی حافظه‌ی نهان فونت..."
            message1="خطا"
            message2="دستورات زیر نصب نشده‌اند"
            message3="همه‌ی دستورات وجود دارند."
            message4="فونت %s قبلاً نصب شده است، نادیده گرفته می‌شود..."
            message5="در حال نصب %s..."

            ;;

        sl ) # Slovenian / Esloveno

            ok='Namestitev pisave(-e) je končana.'
            title_ok='Namestitveni program za pisave'
            title_wait='Posodabljanje'
            wait='Posodabljanje seznama pisav...'
            errors='Prišlo je do napak'
            title_errors='Napaka'
            copying_fonts='Kopiranje pisav je v teku...'
            yad_not_installed="Program Yad ni nameščen."
            invalid_source_file="Izbrana ni bila nobena veljavna izvorna datoteka."
            updatecachefonts="Posodabljanje predpomnilnika pisav..."
            message1="Napaka"
            message2="Naslednji ukazi niso nameščeni"
            message3="Vsi ukazi so prisotni."
            message4="Pisava %s je že nameščena, ignoriranje..."
            message5="Nameščanje %s..."

            ;;

        sr ) # Serbian / Sérvio

            ok='Инсталација фонта(ова) је завршена.'
            title_ok='Инсталатер фонта'
            title_wait='Ажурирање'
            wait='Ажурирање листе фонтова...'
            errors='Дошло је до грешака'
            title_errors='Грешка'
            copying_fonts='Копирање фонтова у току...'
            yad_not_installed="Програм Yad није инсталиран."
            invalid_source_file="Није изабрана важећа изворна датотека."
            updatecachefonts="Ажурирање кеш меморије фонта..."
            message1="Грешка"
            message2="Следеће команде нису инсталиране"
            message3="Све команде су присутне."
            message4="Фонт %s је већ инсталиран, игнорише се..."
            message5="Инсталирање %s..."

            ;;

        kk ) # Kazakh / Cazaque

            ok='Қаріп(тер)ді орнату аяқталды.'
            title_ok='Қаріп орнатушысы'
            title_wait='Жаңартылуда'
            wait='Қаріптер тізімі жаңартылуда...'
            errors='Қателер орын алды'
            title_errors='Қате'
            copying_fonts='Қаріптер көшірілуде...'
            yad_not_installed="Yad бағдарламасы орнатылмаған."
            invalid_source_file="Жарамды бастапқы файл таңдалмаған."
            updatecachefonts="Қаріп кэшін жаңарту..."
            message1="Қате"
            message2="Келесі командалар орнатылмаған"
            message3="Барлық командалар бар."
            message4="%s қаріпі орнатылған, елемейді..."
            message5="%s орнатылуда..."

            ;;

        kl ) # Greenland / Groenlandês

            ok='Font(it) ikkussuunneqarnerat naammassineqarpoq.'
            title_ok='Font-inik ikkussisartoq'
            title_wait='Nutarterineq'
            wait='Font-list-ip nutarterneqarnera...'
            errors="Kukkusoqarpoq'."
            title_errors='Ajutoorneq'
            copying_fonts='Fontinik kopierineq ingerlanneqarpoq...'
            yad_not_installed="Yad-programmi ikkussuunneqanngilaq."
            invalid_source_file="Source-fil-i atuuttoq toqqarneqanngilaq."
            updatecachefonts="Fontcache nutarterlugu..."
            message1="Ajutoorneq"
            message2="Peqqussutit uku installerneqanngillat"
            message3="Peqqussutit tamarmik nassaassaapput."
            message4="Font %s installereersimavoq, soqutiginagu..."
            message5="%s-imik ikkussineq..."

            ;;

        ne ) # Nepalese / Nepalês

            ok='फन्ट(हरू) स्थापना पूरा भयो।'
            title_ok='फन्ट स्थापनाकर्ता'
            title_wait='अद्यावधिक गर्दै'
            wait='फन्ट सूची अद्यावधिक गर्दै...'
            errors="त्रुटिहरू देखा पर्यो'"
            title_errors='त्रुटि'
            copying_fonts='फन्टहरू प्रतिलिपि गर्ने काम भइरहेको छ...'
            yad_not_installed="याद कार्यक्रम स्थापना गरिएको छैन।"
            invalid_source_file="कुनै मान्य स्रोत फाइल चयन गरिएको छैन।"
            updatecachefonts="फन्ट क्यास अद्यावधिक गर्दै..."
            message1="त्रुटि"
            message2="निम्न आदेशहरू स्थापना गरिएका छैनन्"
            message3="सबै आदेशहरू उपस्थित छन्।"
            message4="फन्ट %s पहिले नै स्थापित छ, बेवास्ता गर्दै..."
            message5="%s स्थापना गर्दै..."

            ;;

        ka ) # Georgian / Georgiano

            ok='შრიფტ(ებ)ის ინსტალაცია დასრულდა.'
            title_ok='შრიფტის ინსტალატორი'
            title_wait='განახლება'
            wait='შრიფტების სიის განახლება...'
            errors='შეცდომები მოხდა'
            title_errors='შეცდომა'
            copying_fonts='შრიფტების კოპირება მიმდინარეობს...'
            yad_not_installed="Yad პროგრამა არ არის დაინსტალირებული."
            invalid_source_file="სწორი საწყისი ფაილი არ არის არჩეული."
            updatecachefonts="შრიფტების ქეშის განახლება..."
            message1="შეცდომა"
            message2="შემდეგი ბრძანებები არ არის დაინსტალირებული"
            message3="ყველა ბრძანება არსებობს."
            message4="შრიფტი %s უკვე დაინსტალირებულია, იგნორირებულია..."
            message5="%s-ის ინსტალაცია..."

            ;;

        en_US* ) # 🇺🇸 English / Inglês

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

        * ) # 🇺🇸 Default to English if system language not matched

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

        yad --center \
            --window-icon="$logo" \
            --title="$message1" \
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

