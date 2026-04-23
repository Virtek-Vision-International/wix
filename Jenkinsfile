node(label: 'VS2022Pro && DotNetSdk9')
{
    try
    {
        // Clean before building each module
        stage('Checkout')
        {
            // Details of the source repository are in the Jenkins configuration for this build.
            checkout scm
        }
        
        stage('Clear NuGet Caches')
        {
            dotnetNuGetLocals operation: 'clear'
        }
        
        try
        {
            stage('Build and Publish')
            {
                def vsTool = tool ('VS 2022')
                def vsDevCmd = "${vsTool}\\..\\..\\..\\Common7\\Tools\\VsDevCmd.bat"
                bat (
                    label: "Run Virtek Build",               
                    script: "\"${vsDevCmd}\" && .\\virtekbuild.cmd")

                mstest testResultsFile: 'build/logs/TestResults/*.trx', failOnError: false
            }
        }
        finally
        {
            // Post-build steps
            stage ('Post-build Steps')
            {
                zip archive: true, defaultExcludes: false, dir: 'build/logs', exclude: '', glob: '*.binlog', overwrite: true, zipFile: 'build-logs.zip'
                
                archiveArtifacts(
                    artifacts: 'build/artifacts/*',
                    caseSensitive: false,
                    followSymlinks: false)
                
                step([$class: 'Mailer', recipients: 'matt.gallant@ametek.com', notifyEveryUnstableBuild: true])
            }    
        }
    }//try
    catch (err)
    {
        Error(err)
    }
}

def Error(err)
{
    currentBuild.result = "FAILED"
    echo "Catch currentResult: ${currentBuild.currentResult}"
    emailext body: '''
    $PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS.
    Check $BUILD_URL to view logs.
    ''', recipientProviders: [developers(), culprits()], subject: '[$BUILD_STATUS] - $PROJECT_NAME - Build # $BUILD_NUMBER'
    throw err
}