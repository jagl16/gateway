rootProject.name = "platform.cloud"

apply(from = "buildSource/settings.gradle.kts")

include(
    "libraries:api",
    "libraries:test",
    "services:hello-world"
)
