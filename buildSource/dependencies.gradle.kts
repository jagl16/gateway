val dependencyVersions = mapOf(
    "com.netflix.nebula:gradle-resolution-rules" to "latest.release",
    "com.nhaarman.mockitokotlin2:mockito-kotlin" to "2.2.0",
    "org.junit.jupiter" to "5.5.2",
    "org.springframework.boot:spring-boot-starter" to "2.3.1.RELEASE",
    "org.springframework.boot:spring-boot-starter-webflux" to "2.3.1.RELEASE",
    "org.springframework.boot:spring-boot-starter-test" to "2.3.1.RELEASE"
)

allprojects {
    repositories {
        jcenter()
        maven {
            url = uri("https://plugins.gradle.org/m2/")
        }
    }

    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.version?.isEmpty() != false) {
                (dependencyVersions["${requested.module}"] ?: dependencyVersions[requested.group])?.let(::useVersion)
            }
        }
    }

    extra["dependencyVersions"] = dependencyVersions

    plugins.withType<IdeaPlugin>().configureEach {
        model.module {
            isDownloadJavadoc = false
            isDownloadSources = true
        }
    }
}
