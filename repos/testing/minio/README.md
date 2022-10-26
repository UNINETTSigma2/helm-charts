By installing this package, an instance of [minio](https://minio.io) capable
of storing data/files will be created. After installing, you will be able to
access minio's web interface through a web browser.

[minio](https://minio.io) is a distributed storage server, designed for private cloud infrastructure.


## Features
- The ability to download and upload data/files through a web interface
- Support for sharing data among other users

------

### Advanced
This application uses the following Dockerfile:

- [minio](https://github.com/minio/minio/tree/c433572/Dockerfile)

#### Values
| Value name    | Description |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| advanced.rootUser | The username to use for logging in. |
| advanced.rootPassword | The password to use for logging in. |
