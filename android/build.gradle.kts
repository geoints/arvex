allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    afterEvaluate {
        extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.let { libraryExt ->
            if (libraryExt.namespace == null || libraryExt.namespace.isNullOrEmpty()) {
                libraryExt.namespace = "com.arvex.${project.name}"
            }
        }
        extensions.findByType(com.android.build.gradle.AppExtension::class.java)?.let { appExt ->
            if (appExt.namespace == null || appExt.namespace.isNullOrEmpty()) {
                appExt.namespace = "com.arvex.${project.name}"
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
