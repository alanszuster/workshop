FROM ubuntu:20.04

#Ustawiamy zmienną, by APT nie zadawał pytań interaktywnych
ENV DEBIAN_FRONTEND=noninteractive

# - python3, pip i venv – do uruchomienia Jupytera
# - ca-certificates i curl – przydatne narzędzia systemowe
# --no-install-recommends – minimalizuje zbędne zależności
# Na końcu usuwamy cache APT, aby zmniejszyć rozmiar obrazu
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        ca-certificates \
        curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#Ustawiamy katalog roboczy wewnątrz kontenera
WORKDIR /app

#Tworzymy środowisko virtualenv (dla izolacji, choć kontener już ją zapewnia)
RUN python3 -m venv venv

#Dodajemy virtualenv do PATH, by domyślnie używać zainstalowanych tam pakietów
ENV PATH="/app/venv/bin:$PATH"

#Instalujemy Jupyter Notebook w środowisku virtualenv
# --no-cache-dir – nie zapisuje tymczasowych plików → oszczędność miejsca
RUN pip install --no-cache-dir jupyter

#Eksponujemy port 8888, na którym działa Jupyter Notebook
EXPOSE 8888

#Ustawiamy domyślne polecenie po uruchomieniu kontenera
# --ip=0.0.0.0 – pozwala na dostęp z zewnątrz
# --no-browser – nie otwiera przeglądarki
# --allow-root – pozwala na uruchomienie jako root (częste w kontenerach)
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
