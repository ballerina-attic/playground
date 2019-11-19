export function loadSample(fileName: string): Promise<string> {
    return new Promise((resolve, reject) => {
        const req = new XMLHttpRequest();
        req.onreadystatechange = function() {
            if (this.readyState === 4) {
                if (this.status === 200) {
                    resolve(this.responseText);
                } else {
                    reject("File load error: " + fileName + " Status Code: " + this.status);
                }
            }
        };
        req.open("GET", "https://gist.githubusercontent.com/ballerina-github-bot/9253206c6817489fbda3369910e6fae4/raw/5ea7a071f21d2576569beb94b01002028bef5df1/hello_world.bal", true);
        req.send();
    });
}
