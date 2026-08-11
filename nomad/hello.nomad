job "hello-devops" {
  datacenters = ["dc1"]
  type        = "service"

  group "hello" {
    task "hello" {
      driver = "docker"

      config {
        image      = "devops-hello:latest"
        force_pull = false
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
