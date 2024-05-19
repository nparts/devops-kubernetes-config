# DevOps Kubernetes Configs

This project contains manifest files to setup a namespace for a group/team within a kubernetes cluster. This namespace can be used by the users of this group to publish there solutions on to the cluster. This can be done by applying there own kubernetes manifest file with a ReplicaSet object defined.

---

### generate.sh Script Documentation

#### Description

This Bash script is designed to generate YAML configuration files based on template files. The script processes template files located in a specified directory and generates multiple output files, replacing placeholders with group numbers. The user can specify the number of groups to generate, the template directory, the output directory, and additional options to control the behavior of the script.

#### Usage

```bash
./generate.sh [options]
```

#### Options

- `-t <template_directory>`: Specify the directory containing the template files. Default is `./templates/`.
- `-d <output_directory>`: Specify the directory where the output files will be generated. Default is `./output/`.
- `-n <number_of_groups>`: Specify the number of groups for which the files should be generated. The value must be between 1 and 99. Default is `1`.
- `-c`: Create the output directory if it does not exist.
- `-f`: Force overwrite of existing files.

#### Example Usage

##### Example 1: Basic Usage

Generate files using the default template and output directories, with one group.

```bash
./generate.sh
```

**Expected Output:**

```
Generated ./output/sample-group01.yaml
```

##### Example 2: Specifying Directories and Number of Groups

Generate files using a specified template directory, output directory, and for three groups.

```bash
./generate.sh -t /path/to/templates -d /path/to/output -n 3
```

**Expected Output:**

```
Generated /path/to/output/sample-group01.yaml
Generated /path/to/output/sample-group02.yaml
Generated /path/to/output/sample-group03.yaml
```

##### Example 3: Creating Output Directory

Generate files and create the output directory if it does not exist.

```bash
./generate.sh -d /new/output/directory -c
```

**Expected Output:**

```
Generated /new/output/directory/sample-group01.yaml
```

##### Example 4: Force Overwrite Existing Files

Generate files and force overwrite of existing files.

```bash
./generate.sh -f
```

**Expected Output:**

```
Generated ./output/sample-group01.yaml
```

#### Detailed Script Explanation

1. **Default Values:** The script sets default values for template directory, output directory, number of groups, and flags for creating directories and force overwriting.
2. **Command-line Argument Parsing:** The script parses command-line arguments to allow the user to override the default values.
3. **Directory Checks:** The script checks if the output directory exists and is writable. If the `-c` option is used, it creates the directory if it does not exist.
4. **Group Number Validation:** The script validates that the number of groups is between 1 and 99.
5. **File Generation:** The script processes each template file in the specified template directory, replacing placeholders with group numbers, and generates the output files in the specified output directory.
6. **Permissions Adjustment:** The script sets permissions for the generated YAML files to be readable and writable only by the owner.


