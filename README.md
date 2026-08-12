# Assignment-7_Linux

## 📌 Objective

The objective of this assignment is to create a Bash utility named `buildMaven.sh` to manage common build operations of a Maven-based Java project.

The utility supports:

* Generate project artifact
* Install artifact into local Maven repository
* Perform static code analysis

  * Checkstyle
  * FindBugs
  * PMD
* Execute unit tests
* Generate code coverage
* Deploy WAR artifact to Apache Tomcat
* Generate application documentation *(optional)*

---

## 📂 Project Used

GitHub Repository:

https://github.com/opstree/spring3hibernate.git

Clone the repository:

```bash
git clone https://github.com/opstree/spring3hibernate.git
cd spring3hibernate
```

---

# 🏗️ Overall Architecture

```mermaid
flowchart TD
    A[Java Source Code] --> B[Maven Project]
    B --> C[buildMaven.sh]

    C --> D[Generate Artifact]
    C --> E[Install Artifact]
    C --> F[Static Code Analysis]
    C --> G[Unit Testing]
    C --> H[Code Coverage]
    C --> I[Deploy]

    F --> F1[Checkstyle]
    F --> F2[FindBugs]
    F --> F3[PMD]

    G --> G1[Surefire]

    H --> H1[JaCoCo]

    D --> J[target/*.war]
    E --> K[~/.m2/repository]
    I --> L[Apache Tomcat 9]

    L --> M[Web Application]
```

---

# 🔧 Prerequisites

Install/check the following:

### Java

```bash
java -version
```

Example:

```text
openjdk version "11.0.31"
```

### Maven

```bash
mvn -version
```

### Git

```bash
git --version
```

### Tomcat

Tomcat 9 is installed manually under:

```text
/opt/tomcat9
```

Check:

```bash
ls /opt/tomcat9
```
<img width="1327" height="254" alt="image" src="https://github.com/user-attachments/assets/3cb956c5-b20b-4b0a-b0a8-b7dca4e13557" />

---

# 📁 Project Structure

```text
spring3hibernate/
│
├── pom.xml
├── buildMaven.sh
├── README.md
│
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   │
│   └── test/
│       └── java/
│
└── target/
```

After building and testing:

```text
spring3hibernate/
│
├── pom.xml
├── buildMaven.sh
├── src/
│
└── target/
    ├── *.war
    ├── surefire-reports/
    └── site/
        └── jacoco/
            ├── index.html
            ├── jacoco.csv
            └── jacoco.xml
```

---

# 🚀 buildMaven.sh

The main utility is:

```bash
buildMaven.sh
```

Make the script executable:

```bash
chmod +x buildMaven.sh
```

Run help:

```bash
./buildMaven.sh -h
```

---

# 🏷️ Command-Line Options

| Flag   | Operation                            |
| ------ | ------------------------------------ |
| `-a`   | Generate artifact                    |
| `-i`   | Install artifact to local repository |
| `-s`   | Perform static code analysis         |
| `-t`   | Run unit tests and code coverage     |
| `-d`   | Deploy artifact to Tomcat            |
| `-doc` | Generate documentation               |
| `-h`   | Display help                         |

---

# 1️⃣ Generate Artifact

Command:

```bash
./buildMaven.sh -a
```
<img width="1365" height="399" alt="image" src="https://github.com/user-attachments/assets/dadb5e7b-ade1-4f9b-b681-66255923727a" />


This generates the Maven project artifact.

Internally, Maven performs:

```bash
mvn clean package
```

The generated WAR file is placed inside:

```text
target/
```

Example:

```text
target/Spring3HibernateApp.war
```
<img width="965" height="528" alt="image" src="https://github.com/user-attachments/assets/bdd8ff4f-4582-4737-8d46-80256f7269a6" />

## Figure — Artifact Generation

```mermaid
flowchart LR
    A[Source Code] --> B[mvn clean package]
    B --> C[Compile]
    C --> D[Test]
    D --> E[Package]
    E --> F[WAR Artifact]
    F --> G[target/*.war]
```

Check the artifact:

```bash
ls -lh target/
```

---

# 2️⃣ Install Artifact to Local Repository

Command:

```bash
./buildMaven.sh -i
```

<img width="1365" height="461" alt="image" src="https://github.com/user-attachments/assets/6a52ee2e-33b1-4be6-8ac1-fe681795ae98" />

<img width="1346" height="546" alt="image" src="https://github.com/user-attachments/assets/78f4150b-f93d-451a-9593-fdf068e6864a" />


Equivalent Maven command:

```bash
mvn install
```

The artifact is installed into the local Maven repository:

```text
~/.m2/repository/
```
<img width="1270" height="143" alt="image" src="https://github.com/user-attachments/assets/1279bca2-7e5d-421b-a0b5-6c0cc5692670" />


## Figure — Maven Local Repository

```mermaid
flowchart LR
    A[Maven Project] --> B[mvn install]
    B --> C[Build Artifact]
    C --> D[target/*.war]
    C --> E[Local Maven Repository]
    E --> F[~/.m2/repository]
```

Check:

```bash
ls ~/.m2/repository/
```
<img width="1089" height="408" alt="image" src="https://github.com/user-attachments/assets/ea770275-3151-4058-a0e7-2a264b497b89" />

---

# 3️⃣ Static Code Analysis

The utility supports:

```text
checkstyle
findbugs
pmd
```

Syntax:

```bash
./buildMaven.sh -s <tool>
```

---

## 🔹 Checkstyle

Run:

```bash
./buildMaven.sh -s checkstyle
```

Checkstyle checks source code against coding and formatting standards.

### Figure

```mermaid
flowchart TD
    A[Java Source Code] --> B[Checkstyle]
    B --> C[Style Rules]
    C --> D[Violations / Report]
```

<img width="525" height="67" alt="image" src="https://github.com/user-attachments/assets/99c354aa-e646-4ea6-8a39-384f0b4bafbb" />

<img width="917" height="34" alt="image" src="https://github.com/user-attachments/assets/78f8543b-14de-477f-877b-343a5e1f53c1" />


---

## 🔹 FindBugs

Run:

```bash
./buildMaven.sh -s findbugs
```

FindBugs analyzes Java code for possible bugs and problematic coding patterns.

Example findings from this project include:

```text
NM_FIELD_NAMING_CONVENTION
PT_RELATIVE_PATH_TRAVERSAL
SE_NO_SERIALVERSIONID
```
<img width="1365" height="492" alt="image" src="https://github.com/user-attachments/assets/fe2cc46f-0a80-41d8-9029-0cb8c5fa5be6" />

<img width="743" height="650" alt="image" src="https://github.com/user-attachments/assets/2c939e8d-b34d-401c-ada7-b7f52590dbcb" />

### Figure

```mermaid
flowchart TD
    A[Java Classes] --> B[FindBugs]
    B --> C[Bytecode Analysis]
    C --> D[Potential Bugs]
    D --> E[FindBugs Report]
```

The project configuration contains:

```xml
<failOnError>false</failOnError>
```

Therefore, reported FindBugs issues do not automatically fail the Maven build.

---

## 🔹 PMD

Run:

```bash
./buildMaven.sh -s pmd
```

PMD performs static source-code analysis and identifies potential code-quality problems.

### Figure

```mermaid
flowchart TD
    A[Source Code] --> B[PMD]
    B --> C[Code Quality Rules]
    C --> D[PMD Report]
```

<img width="893" height="402" alt="image" src="https://github.com/user-attachments/assets/3fbdacb0-9657-49a5-b7dd-e14a40ab5038" />


---

# 4️⃣ Unit Testing

The assignment uses Maven Surefire for unit testing.

Command:

```bash
./buildMaven.sh -t surefire
```
<img width="1365" height="472" alt="image" src="https://github.com/user-attachments/assets/6f3d3ac0-abd2-409a-91d2-28031f8e61ef" />

<img width="1331" height="690" alt="image" src="https://github.com/user-attachments/assets/bd7b2b8f-09a4-435b-8d8b-39f6abc1f5b2" />


Equivalent Maven operation:

```bash
mvn test
```

Test reports are generated in:

```text
target/surefire-reports/
```

Check:

```bash
ls target/surefire-reports/
```
<img width="884" height="98" alt="image" src="https://github.com/user-attachments/assets/d3bd8daa-ea8e-48cb-8184-b1771a8e1599" />

---

## 🧪 Test Result

The project successfully executed:

```text
Tests run: 3
Failures: 0
Errors: 0
Skipped: 0
```

Therefore:

```text
Unit Tests = SUCCESS
```

### Figure — Unit Testing

```mermaid
flowchart TD
    A[Source Code] --> B[Maven Surefire]
    B --> C[Execute Unit Tests]
    C --> D{Test Result}

    D -->|Pass| E[BUILD SUCCESS]
    D -->|Fail| F[BUILD FAILURE]
```

---

# 5️⃣ Code Coverage

Code coverage measures how much application code is executed by unit tests.

The project uses **JaCoCo** for code coverage.

Add the JaCoCo plugin inside the existing `<plugins>` section of `pom.xml`:

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.13</version>

    <executions>
        <execution>
            <id>prepare-agent</id>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>

        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

Run:

```bash
mvn clean test
```

Coverage report:

```text
target/site/jacoco/index.html
```

Check:

```bash
ls target/site/jacoco/
```

Expected files:

```text
index.html
jacoco.csv
jacoco.xml
```

### Figure — Code Coverage

```mermaid
flowchart LR
    A[Unit Tests] --> B[JaCoCo Agent]
    B --> C[Execute Application Code]
    C --> D[Collect Coverage Data]
    D --> E[Generate Report]
    E --> F[target/site/jacoco/index.html]
```

---

# 6️⃣ Deploy Artifact to Tomcat

Command:

```bash
./buildMaven.sh -d
```
<img width="733" height="333" alt="image" src="https://github.com/user-attachments/assets/d6db5a09-a162-4e4e-8b69-a067252f0c33" />


The deployment process copies the generated WAR file to:

```text
/opt/tomcat9/webapps/
```

Check:

```bash
sudo ls -lh /opt/tomcat9/webapps/
```
<img width="728" height="168" alt="image" src="https://github.com/user-attachments/assets/546bfb33-ac20-407a-b61a-baf7e027a804" />

---

## Figure — Tomcat Deployment

```mermaid
flowchart LR
    A[Java Project] --> B[Maven Build]
    B --> C[WAR Artifact]
    C --> D[target/*.war]
    D --> E[/opt/tomcat9/webapps/]
    E --> F[Tomcat 9]
    F --> G[Web Application]
```

#  Complete Command List

Run all commands from the Maven project directory:

```bash
cd ~/spring3hibernate
```

### Help

```bash
./buildMaven.sh -h
```
<img width="596" height="386" alt="image" src="https://github.com/user-attachments/assets/7725c01a-c30a-4a12-943c-c9273b96ec9a" />


### Generate artifact

```bash
./buildMaven.sh -a
```

### Install artifact

```bash
./buildMaven.sh -i
```

### Checkstyle

```bash
./buildMaven.sh -s checkstyle
```

### FindBugs

```bash
./buildMaven.sh -s findbugs
```

### PMD

```bash
./buildMaven.sh -s pmd
```

### Unit tests + coverage

```bash
./buildMaven.sh -t surefire
```

### Deploy to Tomcat

```bash
./buildMaven.sh -d
```

---

# 1️⃣3️⃣ Complete Assignment Workflow

```mermaid
flowchart TD
    A[Clone GitHub Repository] --> B[Enter Project Directory]
    B --> C[Check pom.xml]
    C --> D[Run buildMaven.sh]

    D --> E[-a Generate Artifact]
    E --> F[WAR File]

    D --> G[-i Install Artifact]
    G --> H[~/.m2/repository]

    D --> I[-s Static Analysis]
    I --> I1[Checkstyle]
    I --> I2[FindBugs]
    I --> I3[PMD]

    D --> J[-t Unit Testing]
    J --> K[Surefire]
    K --> L[JaCoCo Coverage]

    D --> M[-d Deployment]
    M --> N[Tomcat 9]
    N --> O[Web Application]
```

---

# 1️⃣4️⃣ Final Result

The assignment combines:

```text
Bash
  +
Maven
  +
Java
  +
Checkstyle
  +
FindBugs
  +
PMD
  +
Surefire
  +
JaCoCo
  +
Tomcat 9
```

into one automation utility:

```text
                buildMaven.sh
                      │
       ┌──────────────┼──────────────┐
       │              │              │
       ▼              ▼              ▼
     Build         Analyze         Test
       │              │              │
       ▼        ┌─────┼─────┐        ▼
      WAR       │     │     │    Surefire
       │        ▼     ▼     ▼        │
       │   Checkstyle FindBugs PMD   ▼
       │                         JaCoCo
       │
       ▼
     Deploy
       │
       ▼
   Tomcat 9
```

## 🎯 Conclusion

The `buildMaven.sh` utility provides a centralized way to perform Maven build operations from the command line.

It simplifies the process of:

1. Building the application
2. Generating the WAR artifact
3. Installing the artifact
4. Performing static code analysis
5. Running unit tests
6. Generating code coverage
7. Deploying the application to Tomcat
8. Generating documentation
9. Applying optional quality gates
