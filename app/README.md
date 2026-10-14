runtime_platform {
  operating_system_family = "LINUX"
  cpu_architecture        = "X86_64"
}
What Each Means
Operating system → The environment the container runs on.
LINUX = Linux
CPU architecture → The processor type.
X86_64 = Intel/AMD
ARM64 = ARM/AWS Graviton
Docker Buildx

buildx builds the Docker image for a specific architecture.

docker buildx build --platform linux/amd64 .

→ Builds for X86_64

docker buildx build --platform linux/arm64 .

→ Builds for ARM64

Key Rule
Terraform ECS architecture
          =
Docker image architecture