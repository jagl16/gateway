description = "Microservice to demonstrate Hello-World"

plugins {
    application

    id("com.google.cloud.tools.jib")
    id("org.jetbrains.kotlin.plugin.spring")
    id("org.springframework.boot")
}

application {
    mainClassName = "cloud.scaling.hello.world.HelloWorldApplicationKt"
}

jib {
    container {
        mainClass = application.mainClassName
    }
}

dependencies {
    implementation(project(":libraries:api"))
    implementation(project(":libraries:test"))
}
