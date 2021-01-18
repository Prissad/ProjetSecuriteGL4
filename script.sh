#!/bin/bash

clear
option=0
while [ $option -le 6 ]
do
	clear
	echo "               OUTIL SSI INSAT POUR LA CRYPTOGRAPHIE           "
	echo " "
	echo " "
	echo "1- codage/decodage d'un message"
	echo "2- Hashage d'un message "
	echo "3- Craquage d'un message hashé"
	echo "4- chiffrement/dechiffrement symetrique d'un message"
	echo "5- chiffrement/dechiffrement asymetrique d'un message"
	echo "*- quitter"
	echo ""

	read -p "choisissez une option : " option;
	case $option in
		1)
		  clear
		  echo "1-coder un message"
		  echo "2-decoder un message"
		  echo ""
		  read -p "Vote choix: " choice
		  case $choice in
			1)echo "saisir le message à coder : "
			read message_a_coder
			echo " le message a été codé : "
			echo $message_a_coder |base64 ;;
			2)echo "saisir le message  à decoder : "
			read message_a_decoder
			echo "le message a été decodé : "
			echo $message_a_decoder |base64 --decode;;
		  esac ;;
		2)
		clear
		echo "saisir le message à hasher: "
		read message_a_hasher
		echo $message_a_hasher > tohash.txt
		echo "choisir la fonction de hashage :"
		echo "1- MD5"
		echo "2- SHA1"
		echo "3- SHA256"
		read h
		case $h in
			1)echo "votre message hashé avec md5 est :"
			 md5sum<<<$message_a_hasher | rev | cut -c 3- | rev;;
			2)echo "votre message hashé avec SHA1 est :"
			 sha1sum<<<$message_a_hasher | rev | cut -c 3- | rev;;
			3)echo "votre message hashé avec SHA256 est :"
			 sha256sum<<<$message_a_hasher | rev | cut -c 3- | rev;;
		esac;;
		3)
		clear
		echo "choisir la fonction de hashage utilisée :"
		echo "1- MD5"
		echo "2- SHA1"
		echo "3- SHA256"
		read craq
		echo "saisir le message hashé qu'il faut craquer: "
		read message_a_craquer
		echo "choisir méthode de craquage: "
		echo "1- Dictionnary Attack"
		echo "2- Annuler"
		read method_craquage
		case $method_craquage in
			1)echo "saisir le nom du dictionnaire (par défaut, default-dictionnary) :"
			read dict
			dict="${dict:-"default-dictionnary"}"
			test_dict=false
			echo "tentative de craquage en cours ..."
			while read line; do				
				case $craq in
					1)hash=$(md5sum<<<$line | rev | cut -c 3- | rev);;
					2)hash=$(sha1sum<<<$line | rev | cut -c 3- | rev);;
					3)hash=$(sha256sum<<<$line | rev | cut -c 3- | rev);;
				esac
				if [ $message_a_craquer = $hash ]; then
					test_dict=true
					echo "craquage réussi! le message original est: "
					echo $line
					break
				fi			
			done < "dict/${dict}.txt"
			if [ $test_dict = false ]; then
				echo "pas de résultat pour ce dictionnaire"
			fi;;
			2);;
		esac;;
		4)
		clear
		echo "1- chiffer"
		echo "2- dechiffrer"
		read c
		case $c in
			1)echo "saisir le message à chiffrer :"
			read message
			echo "saisir le nom du fichier resultant  (xxx.txt.gpg):"
			read output
			echo "choisir l'algorithme de chiffrement symetrique :"
			echo "1- AE256"
			echo "2- BLOWFISH"
			echo "3- TWOFISH"
			echo "4- CAMELLIA256"
			read algo
			case $algo in
				1)gpg -o $output --symmetric --cipher-algo AES256 <<<$message ;;
				2)gpg -o $output --symmetric --cipher-algo BLOWFISH <<<$message ;;
				3)gpg -o $output --symmetric --cipher-algo TWOFISH <<<$message ;;
				4)gpg -o $output --symmetric --cipher-algo CAMELLIA256 <<<$message ;;
			esac;;
			2)echo "saisir le nom du fichier contenant le message à decrypter ( le fichier doit exister dans le meme emplacement du script ):"
       			read encryptedfile
			gpg -d $encryptedfile ;;
		esac;;
		5)
		  clear
		 echo "1- generer une paire de clefs et choisir un algorithme de chiffrement (RSA , DSA ) "
		 echo "2- lister vos paires de clefs "
		 echo "3- chiffrer"
		 echo "4- dechiffrer"
		  read c
		  case $c in
			1)gpg --full-generate-key;;
			2)gpg --list-key;;
			3)clear
			 echo "saisir le nom de votre clef :"
			 read key
			 echo "saisir votre message:"
			 read message
			 echo "choisir la nature de l'operation :"
			 echo "1-crypter votre message"
			 echo "2-signer votre message"
			 read op
			 case $op in
				1)echo "saisir le nom de fichier resultant (xxx.gpg):"
   	                          read output
            	                  gpg -o $output -r $key -e <<<$message;;
				2)echo "saisir le nom de fichier resultant (xxx.signed):"
                         	  read output
                         	  gpg -o $output --local-user $key --sign <<<$message;;
				esac;;
			4)
			echo "sasir la nature de l'operation:"
			echo "1-decrypter un message"
			echo "2-verifier un message"
			echo ""
			read op
			case $op in
				1)echo "saisir le nom du fichier à decrypter (doit exister dans le meme emplacement du script)"
                        	  read encrypted
                        	  gpg -d $encrypted;;
				2)echo "saisir le nom du fichier à verifier (doit exister dans le meme emplacement du script)"
                        	  read signed
                        	  gpg --verify $signed;;
				esac;;
		esac;;
		*)exit ;;
	esac
	echo ""
	echo ""
	echo "(cliquer sur entrer)"
	read x
done


