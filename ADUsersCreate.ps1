# Specify the number of users to create
$userCount = 30

# OU path
$ouPath = "OU=Auser,DC=brainstorm,DC=com"

# Indian names for boys and girls
$indianBoyNames = @("Aarav", "Abhinav", "Aditya", "Akash", "Akshay", "Aman", "Anirudh", "Arjun", "Aryan", "Dev", "Dhruv", "Ekansh", "Ishaan", "Kabir", "Kartik", "Krish", "Mihir", "Neil", "Nihal", "Ojas", "Pranav", "Rohan", "Samar", "Shlok", "Shreyas", "Vivaan", "Yash", "Yuvraj", "Zain", "Zoravar")
$indianGirlNames = @("Aanya", "Aditi", "Ananya", "Anjali", "Dia", "Disha", "Esha", "Gayatri", "Isha", "Jahnavi", "Kavya", "Khushi", "Kiara", "Mahika", "Mansi", "Nandini", "Niya", "Pari", "Piya", "Pranita", "Riya", "Saanvi", "Saisha", "Sanjana", "Tara", "Twinkle", "Vaidehi", "Zara", "Zoya", "Zuri")

# Surnames for boys and girls
$boySurnames = @("Agarwal", "Ahuja", "Anand", "Arora", "Bajaj", "Bhatia", "Bose", "Chakravarty", "Chopra", "Das", "Desai", "Dhawan", "Dutt", "Gandhi", "Gupta", "Jain", "Kapoor", "Khan", "Kumar", "Mehta", "Mittal", "Modi", "Nair", "Pandey", "Patel", "Raj", "Rao", "Sharma", "Singh", "Thakur", "Verma", "Yadav", "Singh", "Joshi", "Shah")
$girlSurnames = @("Agarwal", "Ahuja", "Anand", "Arora", "Bajaj", "Bhatia", "Bose", "Chakravarty", "Chopra", "Das", "Desai", "Dhawan", "Dutt", "Gandhi", "Gupta", "Jain", "Kapoor", "Khan", "Kumari", "Mehta", "Mittal", "Modi", "Nair", "Pandey", "Patel", "Raj", "Rao", "Sharma", "Singh", "Thakur", "Verma")

# Loop to create and move users
for ($i = 1; $i -le $userCount; $i++) {
    # Randomly select a boy or girl name
    $randomBoyName = $indianBoyNames | Get-Random
    $randomGirlName = $indianGirlNames | Get-Random
    $selectedName = if ((Get-Random) -eq 0) { $randomBoyName } else { $randomGirlName }

    # Randomly select a boy or girl surname
    $selectedSurname = if ((Get-Random) -eq 0) { $boySurnames | Get-Random } else { $girlSurnames | Get-Random }

    # Define variables for user information
    $userName = "$selectedName$i"
    $userGivenName = $selectedName
    $userSurname = $selectedSurname
    $userDisplayName = "$selectedName $userSurname DemoUser"
    $userDescription = "Demo User"
    $userPassword = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force

    # Generate username using the first initial of the first name and full last name
    $userFirstNameInitial = $userGivenName.Substring(0, 1)
    $userSamAccountName = "$userFirstNameInitial$userSurname"

    # Create a new user object without prompts
    $userObject = New-ADUser -SamAccountName $userSamAccountName -UserPrincipalName "$userSamAccountName@brainstorm.com" -GivenName $userGivenName -Surname $userSurname -DisplayName $userDisplayName -Description $userDescription -AccountPassword $userPassword -Enabled $true -Path $ouPath

    # Print the logon username on the console
    Write-Host "User $i - Logon Username: $userSamAccountName"
}

Write-Host "$userCount users created and moved to $ouPath."
