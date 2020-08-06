plugins {
    `java-library`

    id("org.jetbrains.kotlin.plugin.spring")
    id("org.springframework.boot") apply false
}

dependencies {
    api("org.springframework.boot:spring-boot-starter-webflux") {
        exclude(module = "spring-boot-starter-tomcat")
    }

    testImplementation(project(":libraries:test"))
}
