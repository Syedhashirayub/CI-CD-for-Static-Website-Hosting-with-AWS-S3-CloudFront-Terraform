# Variable for S3 bucket name
variable "bucketname" {
  description = "Name of the S3 bucket for hosting the website"
  default     = "mystaticwebsite07431"  # Change to a unique bucket name
}

# Variable for website local folder path
variable "website_folder_path" {
  description = "Local path to the folder containing website files"
  default     = "website-folder"  # Change to the path where your website files are stored
}

