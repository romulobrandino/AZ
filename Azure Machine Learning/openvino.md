# Install the Intel® Distribution of OpenVINO™ Toolkit Core Components


1. Download the pre-trained model from here:- https://docs.openvinotoolkit.org/latest/_docs_install_guides_installing_openvino_linux.html or [Install the Intel® Distribution of OpenVINO™ Toolkit Core Components](https://software.intel.com/en-us/openvino-toolkit/choose-download)

2. Unpack the .tgz file:
```bash 
tar -xvzf l_openvino_toolkit_p_<version>.tgz # example tar -xvzf l_openvino_toolkit_p_2020.3.194.tgz
```
The files are unpacked to the l_openvino_toolkit_p_<version> directory.

3. Go to the l_openvino_toolkit_p_<version> directory:
```bash
cd l_openvino_toolkit_p_<version>
```

## Installation Notes:

1. Command-Line Instructions:
```bash
sudo ./install.sh
```
When installed as root the default installation directory for the Intel Distribution of OpenVINO is ```/opt/intel/openvino_<version>/```

## Install External Software Dependencies

These dependencies are required for:

* Intel-optimized build of OpenCV library
* Deep Learning Inference Engine
* Deep Learning Model Optimizer tools

1. Change to the install_dependencies directory:
```bash
cd /opt/intel/openvino/install_dependencies
```
2. Run a script to download and install the external software dependencies:
```bash
sudo -E ./install_openvino_dependencies.sh
```
The dependencies are installed. Continue to the next section to set your environment variables.

## Set the Environment Variables

You must update several environment variables before you can compile and run OpenVINO™ applications. Run the following script to temporarily set your environment variables:
```bash
source /opt/intel/openvino/bin/setupvars.sh
```

**Optional:** The OpenVINO environment variables are removed when you close the shell. As an option, you can permanently set the environment variables as follows:

1. Open the .bashrc file in <user_directory>:
```bash
vi <user_directory>/.bashrc
```
2. Add this line to the end of the file:
```bash
source /opt/intel/openvino/bin/setupvars.sh
```
3. Save and close the file: press the Esc key and type :wq.
4. To test your change, open a new terminal. You will see [```setupvars.sh```] OpenVINO environment initialized.

The environment variables are set. Continue to the next section to configure the Model Optimizer.