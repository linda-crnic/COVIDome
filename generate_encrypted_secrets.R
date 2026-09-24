library("config")
library("cyphr")
library("sodium")

# define database connection parameters
db_conn <- list(
  server = "",
  database = "",
  uid = "",
  pwd = "",
  port = 9999,
  Encrypt = 'yes',
  TrustServerCertificate = 'no',
  ConnectionTimeout = 30
)

json_creds <- jsonlite::toJSON(db_conn, auto_unbox = TRUE)

key_bytes <- sodium::keygen() 
key <-  cyphr::key_sodium(key_bytes)

# encrypted key value
print(base64enc::base64encode(key_bytes))

encrypted_bytes <- cyphr::encrypt_data(
  data = charToRaw(json_creds), 
  key = key
)

db_enc_string <- base64enc::base64encode(encrypted_bytes)

# encrypted database connection string
print(db_enc_string)
