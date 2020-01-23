from http.server import BaseHTTPRequestHandler, HTTPServer
import re
import logging


class HttpProcessor(BaseHTTPRequestHandler):

    MIN_LENGTH = 1
    MAX_LENGTH = 16
    regexp = r"[A-Za-z0-9_]+"
    header_name = 'imsi'

    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)

    handler = logging.FileHandler('report.log')
    handler.setLevel(logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)

    logger.addHandler(handler)

    def _set_response(self):
        self.send_response(200)
        self.end_headers()
        self.logger.info('200 OK')

    def _set_bad_response(self):
        self.send_response(400)
        self.end_headers()
        self.logger.info('400 Bad Request')

    def do_GET(self):
        self._set_response()

    def do_POST(self):
        if self.header_name in self.headers:
            self.logger.info('Headers: ' + str(self.headers))
            if (re.match(self.regexp, self.headers[self.header_name]))\
                    and (self.MIN_LENGTH <= len(self.headers[self.header_name]) <= self.MAX_LENGTH):
                self._set_response()
            else:
                self._set_bad_response()
        else:
            self._set_bad_response()


serv = HTTPServer(('localhost', 80), HttpProcessor)
serv.serve_forever()
