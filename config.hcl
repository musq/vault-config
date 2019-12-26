api_addr = "https://tug.ro"
disable_clustering = true
disable_mlock = true
ui = true

listener "tcp" {
    address = "127.0.0.1:32765"
    proxy_protocol_behavior = "use_always"
    tls_disable = 1
}

storage "file" {
    path = "/var/lib/vault"
}
