Write-Host "Program Started"

# Set country and output file name
$country = 'GB'
$outputFile = "MIF_" + (Get-Date -Format "yyyyMMdd") + ".csv"

# Read DB credentials from environment variables
$dbUser = $env:DB_USER
$dbPass = $env:DB_PASS
$dbName = "MFMT_GB_QA"

# Build SQL connection string
$sconstring = "Data Source=cdarcpsuatmi.1a278996aad1.database.windows.net;Initial Catalog=$dbName;User ID=$dbUser;Password=$dbPass"
$scon = New-Object System.Data.SqlClient.SqlConnection
$scon.ConnectionString = $sconstring

# Prepare SQL query
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.Connection = $scon
$cmd.CommandText = "SELECT TOP 1 * FROM OTPAuthentication WHERE Lock = '0'"
$cmd.CommandTimeout = 0

# Execute SQL and get data
$sqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$sqlAdapter.SelectCommand = $cmd
$dataSet = New-Object System.Data.DataSet
$sqlAdapter.Fill($dataSet)

# Write some data to output file
foreach ($row in $dataSet.Tables[0].Rows) {
    $line = "$($row["RegId"]);$($row["HHID"]);$($row["FirstName"]);$($row["email"])"
    $line | Out-File $outputFile -Append
}

Write-Host "Program Completed"
