
## Searches through multiple folder with compressed/zipped eCRs
        $compressed = "Z:\folderwithcompressedeCRs1",
        "Z:\folderwithcompressedeCRs2",
        "Z:\folderwithcompressedeCRs3"


$expand_folder = "C:\Users\expand_folder"

$transform_folder = "C:\Users\transform_folder"

$output_folder = "C:\Users\output_folder"

$XSLT_file_RCTC = "C:\Users\Check Against RCTC Version2.xsl"

$csv_name = "RCTC Validation Check"
$csvExt = ".csv"


function Get-ValueSet {

param($Trail)

Remove-Item (-join( $expand_folder,"\", "*.xml"))
Remove-Item (-join( $expand_folder,"\", "*.html"))


Expand-Archive -Path $Trail -DestinationPath $expand_folder -Force 


$rawfile = Get-ChildItem -Path $expand_folder -Filter "*CR.xml" -Name
$rawfilerr = Get-ChildItem -Path $expand_folder -Filter "*RR.xml" -Name

$Min_Filesize = 120
$Max_Filesize = 10000
$Filesize = (Get-Item -Path (-join( $expand_folder,"\", $rawfile))).Length/1KB

if ($Filesize -lt $Max_Filesize){

    try {
    #Unzipping folder
    $zipname = Get-Item -Path $Trail
    $docName = $zipname.BaseName

    $ECR = [XML](Get-Content (-join( $expand_folder,"\", $rawfile))) 

    ### To get unique encounters use the named objects below. Comment out $setid and $NameRR = $setid -replace "\|", if using $ecrIdRoot, $ecrIdExt, $ecrDateTime, $ecrDate, and $NameRR = (-join( $ecrIdRoot,$ecrIdExt,"_",$ecrDate,"_ECR")).
    #$setid = $ECR.ClinicalDocument.setId.extension+"_ECR"
    #$NameRR = $setid -replace "\|"

    ### To get all eCRs use the named objects below. Comment out $ecrIdRoot, $ecrIdExt, $ecrDateTime, $ecrDate, and $NameRR (below) if using $setid and $NameRR above.
    $ecrIdRoot = $ECR.ClinicalDocument.id.root
    $ecrIdExt = $ECR.ClinicalDocument.id.extension
    $ecrDateTime = $ECR.ClinicalDocument.effectiveTime.value
    $ecrDate = $ecrDateTime.Substring(0,8)
    $NameRR = (-join( $ecrIdRoot,$ecrIdExt,"_",$ecrDate,"_ECR"))

    $Namexmlrr = $NameRR+".xml"
    $outRR = $NameRR+".xml"

    #Rename file
    Rename-Item -NewName $Namexmlrr -Path (-join( $expand_folder,"\", $rawfile))

    #XSL Transformation
    $XmlUrlResolver = New-Object System.Xml.XmlUrlResolver
    $xslt_settings = New-Object System.Xml.Xsl.XsltSettings
    $xslt_settings.EnableDocumentFunction = 1

    $xsltrr = New-Object System.Xml.Xsl.XslCompiledTransform
    $xsltrr.Load($XSLT_file_RCTC, $xslt_settings, $XmlUrlResolver) 
    $xsltrr.Transform((-join( $expand_folder,"\",$Namexmlrr)),(-join( $transform_folder,"\",$outRR)))

    Remove-Item (-join( $expand_folder,"\", "*.xml"))
    Remove-Item (-join( $expand_folder,"\", "*.html"))
    }

    catch {
    # Record Errors in separate CSV file with file path
        $custobject = [PSCustomObject]@{
        Error = ("An error occured: $($_.Exception.Message)" -join " ^ ")
        FilePath = $Trail
        }  | Export-Csv (-join( $output_folder,"\",$csv_name,"_ERRORS",$csvExt)) -Append
    }

    finally {}

 
}
elseif ($Filesize -gt $Max_Filesize) {

    $zipname_NP = Get-Item -Path $Trail
    $docName_NP = $zipname.BaseName
    # Record unprocessed files
        $custobject = [PSCustomObject]@{
        BaseName = $docName_NP
        ZipName = $zipname_NP
        FilePath = $Trail
        FileSize = $Filesize
        }  | Export-Csv (-join( $output_folder,"\",$csv_name,"_Unprocessed",$csvExt)) -Append 


        Remove-Item (-join( $expand_folder,"\", "*.xml"))
        Remove-Item (-join( $expand_folder,"\", "*.html"))
} 

else {}


}




        foreach ($folder in $compressed){

        Get-ChildItem $folder -Recurse -Filter "*.zip" |
        ForEach-Object {Get-ValueSet $_.FullName}
        }


# Below commands can be substituted for the "-Filter "*.zip"" above to filter out specific folder names.
        # -Filter "1.2.840.114350.1.13.###*"
        # -Exclude "1.2.840.114350.1.13*"
