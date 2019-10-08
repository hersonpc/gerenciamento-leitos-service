
// const url = "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH&tsyms=REAL,USD,EUR";
//const url = "http://192.168.15.201:3000/data.json"
const domain = "http://tecnologia.isgsaude.org/enfermagem/"
// const url_datafile = domain + "data_scores_enfermagem_hdt.json"
// const url_getfiles = domain + "data-files.json"

const app = new Vue({
  el: '#app',
  data: {
    loading: true,
    showIndice: 0,
    showMenubar: false,
  	intervalID: 0,
  	viewResume: false,
  	dataRef: '',
    dataUpdate: '',
    dataFileURL: '',
    listaDatafiles: [],
    listaDatafilesIndex: -1,
    results: [],
    empresa_sigla: 'hdt',
    mobile_resumido: true,
  },
  created() {
    window.addEventListener('keydown', (e) => {
      console.log("key", e.key)
      if (e.key == 'Escape') {
        this.showMenubar = !this.showMenubar;
      }
      if(e.key == 'ArrowLeft') {
        this.prevPage()
      }
      if(e.key == 'ArrowRight') {
        this.nextPage()
      }
    });
  },
  mounted() {
    
    Swal.showLoading()
    this.redirectIfMobile()

    this.identificaNavegacaoDaUnidadeInternacao()

    // this.lastDataFile()
    this.fetchData()
    this.intervalID = setInterval(() => {
      // this.lastDataFile()
      this.fetchData()
    }, 15000)
  },
  methods: {
    // lastDataFile() {
    //   console.log('Localizando arquivo de dados mais recente...')
    //   axios.get(url_getfiles).then(res => {
    //     console.log(res.data, res.data.children.length)
    //     this.listaDatafiles = []
    //     res.data.children.map((key, index) => {
    //       this.listaDatafiles.push(key.path)
    //     })
    //     console.log(this.listaDatafiles)
    //     this.listaDatafilesIndex = res.data.children.length -1
    //     console.log(this.listaDatafiles[this.listaDatafilesIndex])
    //     const arq_mais_recente = res.data.children[res.data.children.length -1].path
    //     this.dataFileURL = domain + arq_mais_recente
    //     this.fetchData(this.dataFileURL)
    //   })
    // },
    getURL() {
        sigla = this.getParameterByName('sigla');
        if( sigla ) {
          this.empresa_sigla = sigla;
        }
        
        return domain + "data_scores_enfermagem_" + ( this.empresa_sigla ? this.empresa_sigla : 'hdt' ) + ".json";
    },
    identificaNavegacaoDaUnidadeInternacao() {
      unidadeID = parseInt(this.getParameterByName('idx'))
      if(unidadeID > 0) {
        this.showIndice = unidadeID
      }
    },
    getParameterByName(name, url) {
      if (!url) url = window.location.href;
      name = name.replace(/[\[\]]/g, '\\$&');
      var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
          results = regex.exec(url);
      if (!results) return null;
      if (!results[2]) return '';
      return decodeURIComponent(results[2].replace(/\+/g, ' '));
    },
  	fetchData() {
      url = this.getURL()
      // console.log('Atualizando... ' + url)
      axios.get(url).then(res => {
        this.dataRef = res.data.DATA_REF
        this.dataUpdate = res.data.DATA_ATUALIZACAO
        this.results = res.data.UNIDADES
        setTimeout(() => {
          if(this.loading) {
            Swal.hideLoading()
            Swal.close()
          }
          this.loading = false
          }, 1000)
        
      })
    },
  	boxStyle(item) {
    	return {
      	leitoVago: item.SCORE == "VAGO",
        leitoOkay: item.SCORE == "0 ~ 12 DIAS",
        leitoAlerta1: item.SCORE == "13 ~ 24 DIAS",
        leitoAlerta2: item.SCORE == "> 24 DIAS"
      }
    },
    leitoStyle(item) {
      return { 
          'leito-status-pendente': (item.STATUS == 2) && this.isScorePendente(item) && (item.TP_OCUPACAO != 'R')
        , 'leito-status-ok': (item.STATUS == 2) && !this.isScorePendente(item) && (item.TP_OCUPACAO != 'R')
        , 'leito-status-vazio': (item.STATUS == 1)
        , 'leito-status-reservado': (item.STATUS == 2) && (item.TP_OCUPACAO == 'R')
        , 'leito-status-precaucao': (item.STATUS == 3) && (item.TP_OCUPACAO == 'C')
        , 'leito-status-manutencao': (item.STATUS == 3) && (item.TP_OCUPACAO == 'M')
        , 'leito-status-bloqueado': (item.STATUS == 3) && (item.TP_OCUPACAO != 'M') && (item.TP_OCUPACAO != 'C')
        , 'leito-status-alerta-mews': (item.STATUS == 2) && (parseInt(this.getScore('MEWS', item)) >= 4)
        , 'leito-status-girar-leito': (parseInt(item.TEMPO_ULT_MOV) >= 15)
        , 'leito-status-longa-internacao': (parseInt(item.TEMPO_INTERNACAO) >= 24)
      }
    },
    titulo(item) {
      if(item.STATUS == 1) {
        return 'Vago'
      }
      if((item.STATUS == 2) && this.isScorePendente(item) && (item.TP_OCUPACAO != 'R')) {
        return 'Ocupado/Pendente'
      }
      if((item.STATUS == 2) && (item.TP_OCUPACAO == 'R')) {
        return 'Reservado'
      }
      if((item.STATUS == 3)) {
        return 'Bloqueado'
      }
      if((item.STATUS == 2)) {
        return 'Ocupado'
      }
    },
    containsKey(obj, key) {
      return Object.keys(obj).includes(key);
    },
    hasScore(scoreName, objRef) {
      // confirma se exite o elemento SCORES no objeto
      if (this.containsKey(objRef, 'SCORES')) {
        if (this.containsKey(objRef.SCORES, scoreName)) {

          for (key in objRef.SCORES) {
            if (key == scoreName) {
              return (objRef.SCORES[key].length > 0)
              // console.log('KEY', key, objRef.SCORES[key], objRef.SCORES[key].length)
            }
          }

        }
      }

      return(false)
    },
    isScorePendente(objRef) {
      // confirma se exite o elemento SCORES no objeto
      if (this.containsKey(objRef, 'SCORES')) {
          for (key in objRef.SCORES) {
            if (objRef.SCORES[key].length <= 0) {
              return (true)
              // console.log('KEY', key, objRef.SCORES[key], objRef.SCORES[key].length)
            }
          }
      }

      return(false)
    },
    getScore(scoreName, objRef) {
      // confirma se exite o elemento SCORES no objeto
      if (this.containsKey(objRef, 'SCORES')) {
        if (this.containsKey(objRef.SCORES, scoreName)) {

          for (key in objRef.SCORES) {
            if (key == scoreName) {
              if (objRef.SCORES[key].length > 0) {
                console.log('found score value', objRef.SCORES[key][0].RESULTADO)
                return(objRef.SCORES[key][0].RESULTADO)
              }
              // console.log('KEY', key, objRef.SCORES[key], objRef.SCORES[key].length)
            }
          }

        }
      }

      return("-")
    },
    styleLeito(item) {
      console.log('styleLeito', item)
      return 
          "{ 'leito-status-alerta-mews': true }"
    },
    calcOcupacao(leitosDaUnidade) {
      var numLeitos = leitosDaUnidade.length;
      var leitosOperacionais = 0;
      var leitosVagos = 0;
      for (leito in leitosDaUnidade) {
        if(parseInt(leitosDaUnidade[leito].STATUS) != 3) {
          leitosOperacionais++;
        }
        if(parseInt(leitosDaUnidade[leito].STATUS) == 1) {
          leitosVagos++;
        }
      }
      var leitosOcupados = (leitosOperacionais - leitosVagos);
      var taxaOcupacao = Math.round((leitosOcupados / leitosOperacionais) *100, -2);
      return(isNaN(taxaOcupacao) ? 0 : taxaOcupacao)
    },
    calcPermanencia(leitosDaUnidade) {
      var leitosOperacionais = 0
      var totalDiasInternacao = 0
      for (leito in leitosDaUnidade) {
        if(parseInt(leitosDaUnidade[leito].TEMPO_ULT_MOV) > 0) {
          leitosOperacionais++
          totalDiasInternacao = totalDiasInternacao + parseInt(leitosDaUnidade[leito].TEMPO_ULT_MOV)
        }
      }
      var mediaPermanencia = Math.round(totalDiasInternacao / leitosOperacionais, -2);
      return(isNaN(mediaPermanencia) ? 0 : mediaPermanencia)
    },
    isMobile() {
      var check = false;
      (function(a){if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4))) check = true;})(navigator.userAgent||navigator.vendor||window.opera);
      return check;
    },
    redirectIfMobile() {
      var urlMobile = 'mobile.html';
      var currentUrl = String(window.location);
      if ((this.isMobile()) && (currentUrl.indexOf(urlMobile) === -1)) {
        window.location = urlMobile;
      }
    },
    navEstrategico() {
      Swal.showLoading();
      window.location = 'estrategico.html?sigla=' + this.empresa_sigla;
    },
    navMobile() {
      Swal.showLoading();
      window.location = 'mobile.html?sigla=' + this.empresa_sigla;
    },
    navOperacional(indice = 0) {
      window.location = 'index.html?sigla=' + this.empresa_sigla + '&idx=' + indice;
    },
    navPage() {
      if (history.pushState) {
        var newurl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?sigla=' + this.empresa_sigla + '&idx=' + this.showIndice;
        window.history.pushState({path:newurl},'',newurl);
      }
    },
    prevPage() {
      this.showIndice--;
      if (this.showIndice < 0) {
        this.showIndice = this.totalSetores;
      }
      this.navPage()
    },
    nextPage() {
      this.showIndice++;
      if (this.showIndice > this.totalSetores) {
        this.showIndice = 0;
      }
      this.navPage()
    },
    info(item) {
      let tipoAlerta = 'info';
      let content = "";
      if(item.STATUS == 1)
        content = ('<strong style="color:orangered;font-size:1.8em">LEITO VAGO</strong>');
      if((item.STATUS == 2) && (item.TP_OCUPACAO == 'R')) {
        tipoAlerta = 'warning';
        content = ('RESERVADO PELO SISTEMA DE REGULAÇÃO');
      }
      if((item.STATUS == 3) && (item.TP_OCUPACAO == 'C')){
        tipoAlerta = 'warning';
        content = ('ISOLAMENTO PRECAUÇÃO');
      }
      if((item.STATUS == 3) && (item.TP_OCUPACAO == 'M')){
        tipoAlerta = 'warning';
        content = ('LEITO EM MANUTENÇÃO');
      }
      if((item.STATUS == 2) && (item.TP_OCUPACAO != 'R')) {
        content = `há <strong>${item.TEMPO_ULT_MOV}</strong> dia(s) Neste leito<br>
                  há <strong>${item.TEMPO_INTERNACAO}</strong> dia(s) Internado<br><br>`;
        console.log(item.SCORES);
        console.log(this.getScore);

        try{
          Object.keys(item.SCORES).forEach(scoreName => {
            let scoreVal = this.getScore(scoreName, item);
            if(scoreVal == "-") {
              scoreVal = "<small style='color:red'>pendente</small>"
            }

            if((scoreName == "MEWS") && (parseInt(this.getScore('MEWS', item)) >= 4))
              content += `<strong style="color:red;font-size:1.8em">${scoreName}: ${scoreVal} (ALERTA!)</strong><br>`;
            else
              content += `${scoreName}: <strong>${scoreVal}</strong><br>`;
          });
        } catch (e) {
          //
        }

        if((item.STATUS == 2) && !this.isScorePendente(item) && (item.TP_OCUPACAO != 'R'))
          tipoAlerta = 'success'
        else
          tipoAlerta = 'warning'
      }
      if((item.STATUS == 3) && (item.TP_OCUPACAO != 'M') && (item.TP_OCUPACAO != 'C')){
        tipoAlerta = 'warning';
        content = ('INTERDITADO');
      }

      Swal.fire({
        title: 'LEITO '+ item.DS_LEITO,
        html: content.toUpperCase(),
        type: tipoAlerta,
        footer: `<small>Dados atualizado em ${this.dataUpdate}</small>`
      })
    }
  },
  computed: {
    totalSetores()  {
      if (typeof this.results !== 'undefined' && this.results !== null) {
        return (Object.keys(this.results).length -1)
      }
      return (0)
    }
  }
})