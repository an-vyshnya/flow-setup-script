This script is supposed to be used on Ubuntu 20.04 LTS (minimal installation) and requires internet connection and at least 4GB RAM/~30GB HDD. To use it copy to /home/$USER, give permissions (chmod 755 ./install_flow.sh) and run without sudo (./install_flow.sh). Sudo password will be required during the installation though (at least twice: at the beginning and on Qt installation). QtAccount is required and it is strongly recommended to set it up beforehand for the best experience.
Approximate running time: ~30-60 minutes (might be less if some packages are already installed).
To check if everything was installed correctly there are test scripts for cpp and for js.

Этот скрипт предназначен для использования на Ubuntu 20.04 LTS (минимальная инсталляция) и требует интернет соединения и как минимум 4GB RAM/~30GB HDD. Для использования нужно скопировать файл в /home/$USER, дать разрешения (chmod 755 ./install_flow.sh) и запустить без sudo (./install_flow.sh). Но пароль администратора будет нужен в процессе установки (как минимум дважды, на старте и на установке Qt). QtAccount необходим и лучше настроить его заранее.
Приблизительное время исполнения: 30-60 мин (может быть меньше, если некоторые пакеты уже установлены)
Чтобы убедиться, что всё установлено корректно есть тестовые скрипты для cpp и js таргетов.
