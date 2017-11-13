module.exports = {
    build: {
        "index.html": "index.html",
        "app.js": [
            "javascripts/app.js"
        ],
        "app.css": [
            "stylesheets/app.css"
        ],
        "images/": "images/"
    },
    networks: {
        "development": {
            network_id: "default",
            host: '127.0.0.1',
            port: 8545,
            gas: 4000000,
            from: '0x9957A3BcA6D3E1F489195330d26911CB00356f6E'
        }
    },
    rpc: {
        host: "localhost",
        port: 8545
    }
};
