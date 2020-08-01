import com.google.cloud.tools.jib.gradle.JibExtension
import com.google.cloud.tools.jib.gradle.JibPlugin
import nebula.plugin.resolutionrules.ResolutionRulesPlugin
import org.jetbrains.kotlin.gradle.plugin.KotlinPlatformJvmPlugin
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jlleitschuh.gradle.ktlint.KtlintPlugin

plugins {
    base
    idea

    id("com.github.ben-manes.versions")
    id("nebula.resolution-rules")

    id("com.google.cloud.tools.jib") apply false
    id("org.jlleitschuh.gradle.ktlint") apply false

    kotlin("jvm") apply false
}

apply(from = "buildSource/dependencies.gradle.kts")

dependencies {
    resolutionRules("com.netflix.nebula:gradle-resolution-rules")
}

subprojects {
    apply<IdeaPlugin>()
    apply<ResolutionRulesPlugin>()

    tasks {
        withType<ProcessResources> {
            if (name.contains("Test")) dependsOn("compileTestJava") else dependsOn("compileJava")
        }

        withType<KotlinCompile> {
            kotlinOptions {
                freeCompilerArgs = listOf(
                    "-progressive",
                    "-Xinline-classes",
                    "-Xjsr305=strict",
                    "-Xjvm-default=enable"
                )
                jvmTarget = "11"
                javaParameters = true
            }
        }

        withType<Test> {
            useJUnitPlatform()
        }
    }

    plugins.withType<ApplicationPlugin> {
        apply<KotlinPlatformJvmPlugin>()
        apply<KtlintPlugin>()

        dependencies {
            "implementation"(kotlin("stdlib-jdk8"))
        }
    }

    plugins.withType<JavaLibraryPlugin> {
        apply<KotlinPlatformJvmPlugin>()
        apply<KtlintPlugin>()

        dependencies {
            "api"(kotlin("stdlib-jdk8"))
        }
    }
}
