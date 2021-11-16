FROM plone/plone-backend:6.0.0a1-python39

ENV GRAYLOG=logcentral.eea.europa.eu:12201 \
    GRAYLOG_FACILITY=plone-backend

COPY app/ /app/
RUN pip install -r requirements.txt -c constraints.txt ${PIP_PARAMS}
