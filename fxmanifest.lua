name 'greve-db'
author 'greve'
description 'Driveby Skyting Script for CoreRP'
repository 'https://github.com/CoreRPGit/greve-db'


game 'gta5'
version '1.0.0'
fx_version 'cerulean'
lua54 'yes'

dependencies {
    'ox_lib',
    'ox_inventory'
}

shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'client.lua'
}

