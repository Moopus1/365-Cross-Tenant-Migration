<#
  .DESCRIPTION
    Run this in your source ExchangeOnline PowerShell environment.

    This script exports the source information needed for the Cross-Tenant migration preview. It exports the following fields; DisplayName, PrimarySmtp, 
    ExchangeGuid (these must match when creating the mailusers), LegacyExchangeDN, and ArvhiveGuid (if archiving is enabled on the source box). Lastly,
    it will export any additional X500 addresses on the source box (these must also be cloned over).

    The source CSV is any CSV containing the source users UserPrincipalName in a column with the header named UPN. Get this via Admin Center > Users > Export.

  .NOTES
    Name: CrossTenantMigration-Report.ps1
    Author: alexf@macrotg.com
    Version: 1.0
    DateCreated: JUL 2022
#>

$csv = Import-CSV C:\Temp\Users.csv

$csv | ForEach-Object {
    $DisplayName = Get-Mailbox -Identity $_.UPN | Select-Object DisplayName -ExpandProperty DisplayName
    $PrimarySmtp = Get-Mailbox -Identity $_.UPN | Select-Object PrimarySmtpAddress -ExpandProperty PrimarySmtpAddress
    $DestinationSmtp = "EMAIL@DESTINATIONSUFFIX.com"
    $ExchangeGUID = Get-Mailbox -Identity $_.UPN | Select-Object ExchangeGuid -ExpandProperty ExchangeGuid
    $LegacyExchangeDN = Get-Mailbox -Identity $_.UPN | Select-Object LegacyExchangeDN -ExpandProperty LegacyExchangeDN
    $ArchiveGuid = Get-Mailbox -Identity $_.UPN | Select-Object ArchiveGuid -ExpandProperty ArchiveGuid
    $AdditionalX500 = Get-Mailbox -Identity $_.UPN | Select-Object EmailAddresses -ExpandProperty EmailAddresses | where {$_ -match 'X500'}
    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -name 'DisplayName' -Value $DisplayName
    $report | Add-Member -MemberType NoteProperty -name 'PrimarySmtp' -Value $PrimarySmtp
    $report | Add-Member -MemberType NoteProperty -name 'DestinationSmtp' -Value $DestinationSmtp
    $report | Add-Member -MemberType NoteProperty -name 'ExchangeGUID' -Value $ExchangeGUID
    $report | Add-Member -MemberType NoteProperty -name 'LegacyExchangeDN' -Value $LegacyExchangeDN
    $report | Add-Member -MemberType NoteProperty -name 'ArchiveGuid' -Value $ArchiveGuid
    $report | Add-Member -MemberType NoteProperty -name 'AdditionalX500' -Value $AdditionalX500
    $ExportFile = "C:\temp\Export.csv" 
    $report | Export-CSV $ExportFile -NoTypeInformation -Encoding UTF8 -Append  
}
