#!/usr/bin/env zx

let definitions, softwarePackages

async function getSoftwareDefinitions() {
    try {
        return YAML.parse(fs.readFileSync(`${os.homedir()}/.local/share/chezmoi/software.yml`, 'utf8'))
    } catch (e) {
        throw Error('Failed to load software definitions', e)
    }
}

async function writeSoftwareDefinitions() {
    try {
        fs.writeFileSync(`${os.homedir()}/.local/share/chezmoi/software.yml`, YAML.stringify(definitions))
        console.log('Wrote additional data to software.yml')
    } catch (e) {
        throw Error('Failed to write new software definitions file', e)
    }
}

async function populateMissing() {
    definitions = await getSoftwareDefinitions()
    softwarePackages = definitions.softwarePackages
    for (const pkg in softwarePackages) {
        if (softwarePackages[pkg]._github) {
            if (!softwarePackages[pkg]._short) {
                const sgptResponse = await $`sgpt "Describe ${softwarePackages[pkg]._github}. Make the description extremely short."`
                console.log('--- START - SGPT Response for _short Acquired ---')
                console.log(sgptResponse.stdout)
                console.log('--- END - SGPT Response for _short Acquired ---')
                softwarePackages[pkg]._short = sgptResponse.stdout
            }

            if (!softwarePackages[pkg]._desc) {
                const sgptResponse = await $`sgpt "Describe ${softwarePackages[pkg]._github}."`
                console.log('--- START - SGPT Response for _desc Acquired ---')
                console.log(sgptResponse.stdout)
                console.log('--- END - SGPT Response for _desc Acquired ---')
                softwarePackages[pkg]._desc = sgptResponse.stdout
            }

            if (!softwarePackages[pkg]._name) {
                const sgptResponse = await $`sgpt "What is the project name of ${softwarePackages[pkg]._github}? Only print the project name without any additional text."`
                console.log('--- START - SGPT Response for _name Acquired ---')
                console.log(sgptResponse.stdout)
                console.log('--- END - SGPT Response for _name Acquired ---')
                softwarePackages[pkg]._name = sgptResponse.stdout
            }

            //if (!softwarePackages[pkg]._home) {
            //    const sgptResponse = await $`sgpt "What is the project name of ${softwarePackages[pkg]._github}? Only print the project name without any additional text."`
            //    console.log('--- START - SGPT Response for _home Acquired ---')
            //    console.log(sgptResponse.stdout)
            //    console.log('--- END - SGPT Response for _home Acquired ---')
            //    softwarePackages[pkg]._home = sgptResponse.stdout
            //}

            //if (!softwarePackages[pkg]._docs) {
            //    const sgptResponse = await $`sgpt "Print the documentation URL for ${softwarePackages[pkg]._github}. Print only the URL without 'The documentation URL for' text."`
            //    console.log('--- START - SGPT Response for _docs Acquired ---')
            //    console.log(sgptResponse.stdout)
            //    console.log('--- END - SGPT Response for _docs Acquired ---')
            //    softwarePackages[pkg]._docs = sgptResponse.stdout
            //}
        } else if (softwarePackages[pkg]._github === false) {
            console.log('No GitHub repository for ' + pkg)
        } else {
            console.log('***** MISSING GITHUB REPOSITORY INFORMATION FOR ' + pkg + ' *****')
        }
    }
    definitions.softwarePackages = softwarePackages
}

async function main() {
    await populateMissing()
    await writeSoftwareDefinitions()
}

console.log('Running script..')
main()