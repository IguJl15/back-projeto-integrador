# Back End Bot News

## Docs

- [Documento de visão](https://docs.google.com/document/d/1JYcQcsy9NyTRQkKVVJcuyaLhYHUe-mebWZUSBrrwVzs/edit?usp=sharing)
- [Manual do usuário](https://docs.google.com/document/d/1123RUeJ9JtBN-I8s6DNRF9VQUt4moQxaPo8EUzVch0s/edit?usp=sharing)

### Front end: [https://github.com/IguJl15/front-projeto-integrador](https://github.com/IguJl15/front-projeto-integrador)

---

A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

## Setting the environment

- Create a new file named [`.env`](.env) on the project root
- Copy the content from [`.env.example`](.env.example) to [`.env`](.env)
- Change the values from [`.env`](.env) file to the proper configurations
- Run the following commando to generate the env dart class

``` dart
dart run build_runner build -d
```

## Running the sample

### Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker compose`

- First run the Postgresql database server

``` bash
docker compose up postgresql
```

- Once the postgrsql initiated you need to run the following scripts on the database (default proj_integrador_dev)

  - Set up BD extensions: [extensions.sql](https://github.com/KelsonF/Trabalho_BancodeDados/blob/main/extensions.sql)
  - Create tables: [create_tables.sql](https://github.com/KelsonF/Trabalho_BancodeDados/blob/main/create_tables.sql)
  - Create tables: [directions_status.sql](https://github.com/KelsonF/Trabalho_BancodeDados/blob/main/seed/directions_status.sql)
  > You can run the scripts on the container terminal or using any postgresql client, such as:
  >
  > - [pgAdmin](https://www.pgadmin.org/)
  > - [VSCode extension](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-pg)

- Then build up the server

``` bash
docker compose up dart-server
```

You should see the logging:

``` bash
Server listening on InternetAddress('0.0.0.0', IPv4) with port 8080
CONECTADO AO BANCO DE DADOS POSTGRES
```
