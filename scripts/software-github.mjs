#!/usr/bin/env zx
const https = require('https');
const url = require('url');

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

// Function to get the number of stars for a GitHub repository
function getRepoStars(repoUrl, token) {
    return new Promise((resolve, reject) => {
        const { pathname } = url.parse(repoUrl);
        const [, owner, repo] = pathname.split('/');

        const options = {
            hostname: 'api.github.com',
            path: `/repos/${owner}/${repo}`,
            method: 'GET',
            headers: {
                'User-Agent': 'nodejs', // GitHub API requires a User-Agent header
                'Accept': 'application/vnd.github.v3+json', // Specify JSON format for response
                'Authorization': `token ${token}` // Include token in Authorization header
            }
        };

        const req = https.request(options, (res) => {
            let data = '';

            // A chunk of data has been received.
            res.on('data', (chunk) => {
                data += chunk;
            });

            // The whole response has been received.
            res.on('end', () => {
                if (res.statusCode === 200) {
                    const repoInfo = JSON.parse(data);
                    resolve(repoInfo.stargazers_count);
                } else {
                    reject(`Failed to get stars. Status code: ${res.statusCode}`);
                }
            });
        });

        // Handle error events
        req.on('error', (error) => {
            reject(`Error: ${error.message}`);
        });

        req.end();
    });
}

async function populateMissing() {
    definitions = await getSoftwareDefinitions()
    softwarePackages = definitions.softwarePackages
    for (const pkg in softwarePackages) {
        if (softwarePackages[pkg]._github) {
            try {
                softwarePackages[pkg]._stars = await getRepoStars(softwarePackages[pkg]._github, process.env.GITHUB_TOKEN)
            } catch(e) {
                console.log(`Failed to process ${softwarePackages[pkg]._github}`)
            }
        } else if (softwarePackages[pkg]._stars === false) {
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