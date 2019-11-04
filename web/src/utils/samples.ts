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
        req.open("GET", "./samples/" + fileName, true);
        req.send();
    });
}
