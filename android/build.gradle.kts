allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Ganti folder build agar Flutter dan Gradle bisa sharing hasil kompilasi
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Task untuk membersihkan project
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
