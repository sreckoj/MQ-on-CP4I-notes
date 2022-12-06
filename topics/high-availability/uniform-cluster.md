
# IBM MQ - Uniform cluster

The provided [example](uniform-cluster) shows the configuration of the uniform cluster that consists of four queue managers. Queue managers *qm1* and *qm2* are configured with a full cluster repository. Queue managers *qm3* and *qm4* are cluster members with partial repositories.  

See the content of the files including the comments. <br>
- [create_cluster.sh](uniform-cluster/create_cluster.sh) prepares necessary YAMLs from the templates and applies them (note: the files are stored in the *cluster* subdirectory, please don't delete it in order to be able to use it for deleting the cluster)
- [delete_cluster.sh](uniform-cluster/delete_cluster.sh) removes the cluster using previously created YAMLs 
- [tmpl-qm.yaml](uniform-cluster/tmpl-qm.yaml) is a template for queue managers
- [tmpl-cm.yaml](uniform-cluster/tmpl-cm.yaml) is a template for the config map that contains the cluster configuration. This is the most important file. Please review its content. 


>**Important note**: If you decide to change the YAML templates, make sure that there is an additional newline character at the last line of code otherwise the script that generates YAMLs from the templates will not work correctly