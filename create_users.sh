#!/bin/bash

#variabler för användarnamn och lösenord
user_name=$user
password=$password


#för att dubbelkolla att du är inloggad som administratör
if ((EUID ==0 )); then
        echo "Du är inloggad som root, du kan skapa användare"
    else
        echo "Du behöver vara inloggad som root för att kunna skapa användare"
        exit

fi

#kod för att skapa användare
echo "Ange användarnamn: "; read user

#loop för att skapa användare
for users in "$user"; do

echo "Ange lösenord för $users: "; read -s password
echo "Skapar användare för $users"

#skapadent av homekatalog där -m är create home directory. echo "$users:$password" | chpasswd används för att byta ut variablerna i chpasswd så att det skapas ett lösenord för användaren som skapats.
useradd -m $users
echo "$users:$password" | chpasswd

#skapar en textfil i hemkatalogen med ett välkomstmeddelande
echo "
Hej och välkommen $users!
Vad kul att du har skapat ett konto hos oss!
I denna katalog kommer du att hitta alla dina filer.
I din homekatalog har du också mapparna Documents, Downloads och Work som endast du har tillgång till. 

Om du inte kommer ihåg ditt lösenord som skapades i samband kontot så kan du kontakta administratören så hjälper vi dig att återställa det.

Ha en fin dag!
" > /home/$users/welcome.txt

#skapar 3 mappar som användaren kan använda
mkdir /home/$users/Documents
mkdir /home/$users/Downloads
mkdir /home/$users/Work

#sätter rättigheter så bara $users kan komma åt sina filer och mappar
chmod 700 /home/$users/welcome.txt
chmod 700 /home/$users/Documents
chmod 700 /home/$users/Downloads
chmod 700 /home/$users/Work

chown -R $users:$users /home/$users

done
