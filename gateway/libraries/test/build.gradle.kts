plugins {
    `java-library`
}

dependencies {
    api("com.nhaarman.mockitokotlin2:mockito-kotlin")
    api("org.junit.jupiter:junit-jupiter-params")
    runtimeOnly("org.junit.jupiter:junit-jupiter-engine")
}
