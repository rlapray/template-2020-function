async function run(event)
{

    let ret = {};

    ret = {
       'statusCode': 503,
       'statusDescription': '503 Service Unavailable',
       'headers': {
           'Content-Type': 'text/html'
        },
        'body': 'Service unavailable'
    }
    ret.code = 503;
    return ret;
}

exports.handler = run;
