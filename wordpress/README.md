# Attempt to deploy using HELM

Prerequirements:
- Kubernetes and KubeD (Kubernetes + Dataporten), obtain from https://docs.ioudaas.no/access/.
- HELM, obtain from https://github.com/kubernetes/helm, there are binary downloads available.
- Application is deployed on quay.io, deploy yourself with Docker to avoid giving Quay full control over your GitHub account.
- You're standing in the `helm` folder of this repo, it's the folder this README.md file is in.

For more info on Quay, check [this awesome Quay documentation](../QUAY.md).

1. Log in to Dataporten

		kubed -name daas -api-server https://api.ioudaas.no -client-id c89ab13a-68c3-4468-b434-a4bd1c9d2c81 -issuer https://daas-ti.dataporten-api.no

2. Find the name of the tiller instance you'll be using

		kubectl -n appstore-dep get pods | grep tiller | cut -d\  -f1

We'll assume you just found `tiller-1234567890-swagx`.

3. Set up port forwarding

		kubectl -n appstore-dep port-forward tiller-1234567890-swagx 44134:44134 &

4. Deploy this application

		export HELM_HOST=localhost:44134
		helm --namespace appstore-dep install wordpress

5. Find your application

		kubectl -n appstore-dep get pods

It's probably the youngest one.  We'll assume your application's name is `swaggity-swagger-wordpress-1234567890-swagx`.

6. Port forward directly from the running Docker container

		kubectl -n appstore-dep port-forward swaggity-swagger-wordpress-1234567890-swagx 6080:8080

Sometimes the port is used, which you can see from the `Connection refused` messages.
Use a different port then.  Update Dataporten accordingly.

Note that WordPress is strict on following the hostname it gets from..
Kubernetes? Helm? I don't know how all these things hang together..  Anyway,
WordPress will force you to use HTTPS and the hostname that was set
automatically during deploy.  Testing shows thus that Wordpress expects to
run on `https://chart-example.local`.  Update your hosts file accordingly.

Congratulations!  You've now deployed an application all by yourself!


## Usual errors:

### Error: file "wordpress" not found

You weren't standing in the `helm` directory, go read a tutorial on `cd`.

You may notice that it says *file* not found while it actually is looking
for a directory.  That's because **LOOK!** SOMEONE USING ILLUMOS! `runs away`.


### Error: context deadline exceeded

Your portforwarding has fallen down.  This happens regulary.
Just repeat step 2 and 3.  Here's a nice one-liner in three lines:

		kubectl -n appstore-dep port-forward \
		$(kubectl -n appstore-dep get pods | grep tiller | head -n1 | cut -d\  -f1) \
		44134:44134 &
