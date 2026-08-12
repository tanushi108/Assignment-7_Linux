#!/bin/bash

TOMCAT_HOME="/opt/tomcat9"
PROJECT_DIR="$(pwd)"

show_help() {
    echo
    echo "Usage: ./buildMaven.sh [OPTION]"
    echo
    echo "Options:"
    echo "  -a                  Generate Maven artifact"
    echo "  -i                  Install artifact into local Maven repo"
    echo "  -s <tool>           Static code analysis"
    echo "                      Tools: checkstyle, findbugs, pmd"
    echo "  -t <plugin>          Run unit tests and code coverage"
    echo "  -d                  Deploy artifact to Tomcat"
    echo "  -doc                Generate project documentation"
    echo "  -h                  Display this help"
    echo
    echo "Examples:"
    echo "  ./buildMaven.sh -a"
    echo "  ./buildMaven.sh -i"
    echo "  ./buildMaven.sh -s checkstyle"
    echo "  ./buildMaven.sh -s findbugs"
    echo "  ./buildMaven.sh -s pmd"
    echo "  ./buildMaven.sh -t surefire"
    echo "  ./buildMaven.sh -d"
    echo
}

check_maven() {
    if ! command -v mvn >/dev/null 2>&1; then
        echo "[ERROR] Maven is not installed."
        exit 1
    fi
}


check_project() {
    if [ ! -f "pom.xml" ]; then
        echo "[ERROR] pom.xml not found."
        echo "[ERROR] Run this script from the Maven project directory."
        exit 1
    fi
}



generate_artifact() {

    echo
    echo "[INFO] Generating Maven artifact..."
    echo

    mvn clean package

    if [ $? -ne 0 ]; then
        echo
        echo "[ERROR] Maven build failed."
        exit 1
    fi

    echo
    echo "[SUCCESS] Artifact generated successfully."
    echo

    find target -maxdepth 1 -type f \
        \( -name "*.jar" -o -name "*.war" \) \
        -print
}


install_artifact() {

    echo
    echo "[INFO] Installing artifact into local Maven repository..."
    echo

    mvn install

    if [ $? -ne 0 ]; then
        echo
        echo "[ERROR] Artifact installation failed."
        exit 1
    fi

    echo
    echo "[SUCCESS] Artifact installed into local repository."
    echo "[INFO] Local repository: ~/.m2/repository/"
    echo
}


static_analysis() {

    TOOL="$1"

    if [ -z "$TOOL" ]; then
        echo "[ERROR] Static analysis tool is required."
        echo
        echo "Usage:"
        echo "  ./buildMaven.sh -s checkstyle"
        echo "  ./buildMaven.sh -s findbugs"
        echo "  ./buildMaven.sh -s pmd"
        exit 1
    fi

    case "$TOOL" in

        checkstyle)
            echo
            echo "[INFO] Running Checkstyle..."
            echo

            mvn checkstyle:checkstyle

            if [ $? -ne 0 ]; then
                echo "[ERROR] Checkstyle analysis failed."
                exit 1
            fi

            echo
            echo "[SUCCESS] Checkstyle analysis completed."
            echo "[INFO] Report: target/site/checkstyle.html"
            ;;

        findbugs)
            echo
            echo "[INFO] Running FindBugs..."
            echo

            mvn findbugs:findbugs

            if [ $? -ne 0 ]; then
                echo "[ERROR] FindBugs analysis failed."
                exit 1
            fi

            echo
            echo "[SUCCESS] FindBugs analysis completed."
            echo "[INFO] Report: target/site/findbugs.html"
            ;;

        pmd)
            echo
            echo "[INFO] Running PMD..."
            echo

            mvn pmd:pmd

            if [ $? -ne 0 ]; then
                echo "[ERROR] PMD analysis failed."
                exit 1
            fi

            echo
            echo "[SUCCESS] PMD analysis completed."
            echo "[INFO] Report: target/site/pmd.html"
            ;;

        *)
            echo
            echo "[ERROR] Unsupported static analysis tool: $TOOL"
            echo
            echo "Supported tools:"
            echo "  checkstyle"
            echo "  findbugs"
            echo "  pmd"
            exit 1
            ;;

    esac
}



run_tests() {

    PLUGIN="$1"

    if [ -z "$PLUGIN" ]; then
        echo "[ERROR] Unit test plugin/goal is required."
        echo
        echo "Example:"
        echo "  ./buildMaven.sh -t surefire"
        exit 1
    fi

    echo
    echo "[INFO] Running unit tests using: $PLUGIN"
    echo

    if [ "$PLUGIN" = "surefire" ]; then

        mvn test

    else

        mvn "$PLUGIN"

    fi

    if [ $? -ne 0 ]; then
        echo
        echo "[ERROR] Unit tests failed."
        exit 1
    fi

    echo
    echo "[SUCCESS] Unit tests completed."
    echo

    echo "[INFO] Generating code coverage report..."

    mvn jacoco:prepare-agent test jacoco:report

    if [ $? -ne 0 ]; then
        echo
        echo "[ERROR] Code coverage generation failed."
        exit 1
    fi

    echo
    echo "[SUCCESS] Code coverage report generated."
    echo "[INFO] Report: target/site/jacoco/index.html"
    echo
}


deploy_artifact() {

    echo
    echo "[INFO] Deploying artifact to Tomcat..."
    echo

    if [ ! -d "$TOMCAT_HOME" ]; then
        echo "[ERROR] Tomcat installation not found:"
        echo "$TOMCAT_HOME"
        exit 1
    fi

    if [ ! -d "target" ]; then
        echo "[ERROR] target directory does not exist."
        echo "[ERROR] Generate the artifact first using:"
        echo "./buildMaven.sh -a"
        exit 1
    fi

    ARTIFACT=$(find target -maxdepth 1 -type f -name "*.war" | head -1)

    if [ -z "$ARTIFACT" ]; then
        echo "[ERROR] WAR artifact not found in target/"
        echo "[ERROR] Run ./buildMaven.sh -a first."
        exit 1
    fi

    echo "[INFO] Artifact found:"
    echo "$ARTIFACT"

    echo
    echo "[INFO] Copying artifact to Tomcat..."

    sudo cp "$ARTIFACT" "$TOMCAT_HOME/webapps/"

    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to copy artifact to Tomcat."
        exit 1
    fi

    echo
    echo "[INFO] Restarting Tomcat..."

    sudo "$TOMCAT_HOME/bin/shutdown.sh" >/dev/null 2>&1

    sleep 3

    sudo "$TOMCAT_HOME/bin/startup.sh"

    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to start Tomcat."
        exit 1
    fi

    echo
    echo "[SUCCESS] Artifact deployed successfully."
    echo
}


generate_documentation() {

    echo
    echo "[INFO] Generating Maven documentation..."
    echo

    mvn site

    if [ $? -ne 0 ]; then
        echo
        echo "[ERROR] Documentation generation failed."
        exit 1
    fi

    echo
    echo "[SUCCESS] Documentation generated."
    echo "[INFO] Documentation: target/site/index.html"
    echo
}



check_maven
check_project

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

case "$1" in

    -a)
        generate_artifact
        ;;

    -i)
        install_artifact
        ;;

    -s)
        static_analysis "$2"
        ;;

    -t)
        run_tests "$2"
        ;;

    -d)
        deploy_artifact
        ;;

    -doc)
        generate_documentation
        ;;

    -h|--help)
        show_help
        ;;

    *)
        echo
        echo "[ERROR] Invalid option: $1"
        show_help
        exit 1
        ;;

esac
