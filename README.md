# Erisa's Tailscale DERP Docker image

This is [yet](https://github.com/tijjjy/Tailscale-DERP-Docker) [another](https://github.com/fredliang44/derper-docker) take on a Tailscale DERP server in a Docker image.

The guiding principles that distinguish this from alternatives are:

- Compatibility with all [containerboot](https://pkg.go.dev/tailscale.com/cmd/containerboot) environment variables.
- Stable and predictable versioning, using the same version of Tailscale and DERP together to ensure stability. 
- Will not run Tailscale if not desired.
- Full functioning of `/debug/` routes.
- Ease of use. Just clone, set variables, and `docker compose up -d`.
- Support for multiple architectures.

The image is available on `ghcr.io/erisa/ts-derper` with the `:latest` tag serving the latest stable version of Tailscale and some versioned tags being available for specific versions.

## Setup

In short, and assuming you want to verify clients are part of your tailnet:

- Setup DNS records on a subdomain to point to the public IPv4/IPv6 of the machine that's going to run the DERP server. 
- Clone the repository: `$ git clone https://github.com/Erisa/ts-derp-docker && cd ts-derp-docker`
- Create your own copy of the `.env`: `$ cp example.env .env`
- Edit `.env` with an [auth key](https://login.tailscale.com/admin/settings/keys), the domain and an optional hostname.
	- I recommend attaching a tag to your authkey, such as `tag:derpers`.
- Run `docker compose up -d`
- Add the DERP server to your tailnet, as [directed by the documentation](https://tailscale.com/kb/1118/custom-derp-servers#step-2-adding-derp-servers-to-your-tailnet).

The following ports are required by default:

```
80/tcp (HTTP)
443/tcp (HTTPS)
3478/udp (STUN)
```

Port 80 [normally cannot be changed](https://tailscale.com/kb/1118/custom-derp-servers#required-ports), but you are welcome to try and see.

You can change HTTPS and STUN to different ports in the `.env` configuration. You must then update [DERPnode.DERPPort](https://pkg.go.dev/tailscale.com/tailcfg#DERPNode.DERPPort) and [DERPNode.STUNPort](https://pkg.go.dev/tailscale.com/tailcfg#DERPNode.STUNPort) accordingly.

If you need custom certificates, set `TS_DERP_CERTMODE` to `manual` and place the files in `./certs` as `derp.example.com.crt` and `derp.example.com.key`.

## Credits

- [tijjjy](https://github.com/tijjjy) for [Tailscale-DERP-Docker](https://github.com/tijjjy/Tailscale-DERP-Docker)
