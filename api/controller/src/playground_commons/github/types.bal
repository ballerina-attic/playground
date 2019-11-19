public type Gist record {
    string url;
    string id;
    string html_url;
    boolean truncated;
    map<GistFile> files;
    string description;
    boolean 'public;
    string created_at;
    string updated_at;
};

public type GistFile record {
    string filename;
    string 'type;
    string language;
    string raw_url;
    int size;
    boolean truncated;
    string content;
};