<h2 align="center">Android Subsystem for GNU/Linux</h2>

[![Repo size](https://img.shields.io/github/repo-size/lin1328/asl?logo=github&logoColor=white)](https://github.com/lin1328/asl)

<details>
<summary><strong>Currently Supported Systems</strong></summary>

- archlinux
  - `current`
- alpine
  - 3.20
  - `edge`
- centos
  - `9-Stream`
- debian
  - `bookworm`
  - bullseye
  - buster
  - trixie
- ubuntu
  - focal
  - `jammy`
  - noble
  - `oracular`

</details>

> [!NOTE]
> - This module is only for `arm64-v8a`
> - It has been tested only on the versions marked above
> - If there are any bugs, please report them. Compatibility with all devices is not guaranteed

## About the Binary

### Powered by ruri

- Use [ruri](https://github.com/Moe-hacker/ruri) for container runtime
- [rurima](https://github.com/Moe-hacker/rurima) is used for fetching the container rootfs
- The `file` and `curl` command are fake, they actually calls `file-static` and `curl-static` with corrected args
- Thanks: https://github.com/stunnel/static-curl for curl static binary

> [!WARNING]
> Please change the default SSH password immediately  
> Exposing an SSH port without key-based authentication is always a high-risk action!
>
> 请修改默认密码，暴露非密钥认证而是密码认证的ssh端口无论何时都是高危行为！

---

## Thanks

- GitHub: [Lin1328](https://github.com/Lin1328) for the module framework
- Coolapk: 望月古川 for additional framework support
- GitHub: [stunnel](https://github.com/stunnel) for the curl static binary

## Contributing

Contributions are welcome!  
If you want to add support for other operating systems, please submit a corresponding `setup.sh`

## License

希腊奶......
