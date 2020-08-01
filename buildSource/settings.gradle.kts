pluginManagement {
    val pluginVersions = mapOf(
        "com.github.ben-manes.versions" to "0.29.0",
        "com.google.cloud.tools.jib" to "2.4.0",
        "nebula.resolution-rules" to "7.7.6",
        "org.jetbrains.kotlin" to "1.3.72",
        "org.jlleitschuh.gradle.ktlint" to "9.3.0",
        "io.spring.dependency-management" to "1.0.9.RELEASE",
        "org.springframework.boot" to "2.3.1.RELEASE"
    )

    val pluginBlacklist = setOf(
        "org.gradle"
    )

    resolutionStrategy.eachPlugin {
        if (requested.id.namespace !in pluginBlacklist && requested.version?.isEmpty() != false) {
            if (requested.id.id in pluginVersions) {
                useVersion(pluginVersions.getValue(requested.id.id))
            } else if (requested.id.namespace != null) {
                var namespace = requested.id.namespace!!

                do {
                    if (namespace in pluginVersions) {
                        useVersion(pluginVersions.getValue(namespace))

                        break
                    }

                    namespace = namespace.substringBeforeLast('.')
                } while (namespace.contains('.'))
            }
        }
    }

    repositories {
        gradlePluginPortal()
        jcenter()
    }
}

buildCache {
    local {
        isEnabled = true
        isPush = true
        removeUnusedEntriesAfterDays = 5
    }
}
