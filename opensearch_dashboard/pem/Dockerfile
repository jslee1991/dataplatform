FROM opensearchproject/opensearch-dashboards:2.6.0 

USER opensearch-dashboards-dashboards

COPY --chown=opensearch-dashboards:opensearch-dashboards root-cert.pem /usr/share/opensearch-dashboards/config/
COPY --chown=opensearch-dashboards:opensearch-dashboards root-key.pem /usr/share/opensearch-dashboards/config/

