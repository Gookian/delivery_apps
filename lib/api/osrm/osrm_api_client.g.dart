// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'osrm_api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _OsrmApiClient implements OsrmApiClient {
  _OsrmApiClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://router.project-osrm.org/route/v1/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<TripInformation> getOsrmResponse(
    double pointStartLag,
    double pointStartLng,
    double pointEndLag,
    double pointEndLng,
    String overview,
    int alternatives,
    bool steps,
    bool annotations,
    String geometries,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'overview': overview,
      r'alternatives': alternatives,
      r'steps': steps,
      r'annotations': annotations,
      r'geometries': geometries,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<TripInformation>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/car/${pointStartLag},${pointStartLng};${pointEndLag},${pointEndLng}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = TripInformation.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
