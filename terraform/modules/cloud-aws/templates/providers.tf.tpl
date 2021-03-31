%{ for region in regions ~}
provider "aws" {
  alias  = "${region}"
  region = "${region}"
}
%{ endfor ~}
