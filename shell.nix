{ pkgs ? import <nixpkgs> {} }:
let
    kafka = pkgs.apacheKafka;
    preKafka = pkgs.writeShellScript "start.sh"
    ''
        kout=$1
        kid=$kout/kafka_cluster_id
        mkdir -p $kout
        if [ ! -f $kid ]; then
            echo "$(kafka-storage.sh random-uuid)" > $kid
            cp -R ${kafka}/config $kout/config
            kafka-storage.sh format -t $(cat $kid) -c $kout/config/kraft/server.properties
        fi;
        echo $kout
    '';
in
with pkgs;
    mkShell {
        buildInputs = [ kafka ];
        shellHook = ''
            KAFKA_TMP_DATA=.tmp/kafka
            ${preKafka} $KAFKA_TMP_DATA
            echo $KAFKA_TMP_DATA
            function kafkaStart() {
                kafka-server-start.sh $KAFKA_TMP_DATA/config/kraft/server.properties 
            }
        '';
        LOCALE_ARCHIVE = lib.optionalString stdenv.isLinux
            "${pkgs.glibcLocales}/lib/locale/locale-archive";
    }
