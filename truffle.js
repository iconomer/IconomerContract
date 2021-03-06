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
            host: 'localhost',
            port: 8545,
            gas: 4000000,
            gasPrice: 1000000000,
            /**
             * From address must be changed
             */
            from: '0x9957A3BcA6D3E1F489195330d26911CB00356f6E'
        }
    },
    rpc: {
        host: "localhost",
        port: 8545
    },
    solc: {
        optimizer:
            {
                enabled: true,
                runs: 200
            }
    }
};
