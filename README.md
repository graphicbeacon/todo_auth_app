# Todo Auth App

A todo app with authentication. 

## Features

* Register an account
* Authenticate an account
* Create, Read, Update and Delete todos

## Pre-requisites

You will need the following installed:

1. [Dart/Flutter](https://docs.flutter.dev/get-started/install)
2. [Melos CLI](https://melos.invertase.dev/)
2. [Dart Frog CLI](https://dartfrog.vgv.dev/docs/overview#installing-)
3. [LCOV Coverage Testing](https://formulae.brew.sh/formula/lcov)

## Architecture

This project consists of the following packages:

* **todo_auth_client**: Contains logic for Flutter client app
* **todo_auth_server**: Contains logic for Dart server

### todo_auth_client

This project was bootstraped with the `flutter` tooling by running `flutter create todo_auth_client`. You can run the project via the melos cli by doing the following:

```shell
$ melos run start:client # Run Flutter app locally
$ melos run build:client:android # Build Flutter android app apk
$ melos run build:client:ios # Build Flutter ios app ipa
```

Project folder structure is organised in a way to reflect the features exposed by the app. This allows an architecture that can be scaled easily since it does not rely on routing structure.

The current highlighted features are as follows:

```graph
packages/todo_auth_client
|__lib/src
  |__app # Sets up routing and app entry
  |__auth # Contains the logic for auth feature which covers sign in and token management
  |__core # Contains core logic used across other features
  |__register # Contains the logic for registration feature
  |__services # Contains the service logic for communicating with out backend server
  |__todos # Contains the logic for managing our todos
```

### todo_auth_server

This project was bootstrap with the `dart_frog` tooling by running `dart_frog create todo_auth_server`. You can run the server via the melos cli by doing the following:

```shell
$ melos run start:server # Run dev server locally
$ melos run build:server # Build files for running on prod
```

See the **melos.yaml** file at the project root for the list of commands.
