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

- [minio](https://github.com/minio/minio/tree/d5aa2f9/Dockerfile)

#### Values
| Value name    | Description |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| advanced.accessKey | The key / username to use when logging in. |
| advanced.secretKey | The token / password to use when logging in. |
